{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "cp-ksql-server.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "cp-ksql-server.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "cp-ksql-server.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified kafka headless name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "cp-ksql-server.cp-kafka-headless.fullname" -}}
{{- $name := "cp-kafka-headless" -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Form the Kafka URL. If Kafka is installed as part of this chart, use k8s service discovery,
else use user-provided URL
*/}}
{{- define "cp-ksql-server.kafka.bootstrapServers" -}}
{{- if .Values.kafka.bootstrapServers -}}
{{- .Values.kafka.bootstrapServers -}}
{{- else if ( or .Values.global.kafka.ssl.enabled .Values.ssl.enabled ) -}}
{{- $name := default "cp-kafka" .Values.kafka.nameOverride -}}
{{- printf "SSL://%s-%s-0.%s:9092" .Release.Name $name (include "cp-ksql-server.cp-kafka-headless.fullname" .) -}}
{{- else -}}
{{- printf "PLAINTEXT://%s:9092" (include "cp-ksql-server.cp-kafka-headless.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Default Server Pool Id to Release Name but allow it to be overridden
*/}}
{{- define "cp-ksql-server.serviceId" -}}
{{- if .Values.overrideServiceId -}}
{{- .Values.overrideServiceId -}}
{{- else -}}
{{- .Release.Name -}}
{{- end -}}
{{- end -}}

{{/*
Create a secret name depending on if we're using shared SSL settings from a parent chart
*/}}
{{- define "cp-kafka.ssl.secretName" -}}
{{- if .Values.global.kafka.ssl.enabled -}}
{{- printf "%s-%s" .Release.Name "-kafka-ssl-secret" -}}
{{- else -}}
{{- printf "%s-%s" (include "cp-ksql-server.fullname" .) "-ssl-secret" -}}
{{- end -}}
{{- end -}} 
