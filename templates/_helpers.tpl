{{- define "lib.name" -}}
{{- .Values.fullnameOverride | default .Release.Name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "lib.instanceName" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := .Values.instanceName | default .Release.Name }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{- define "lib.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "lib.labels" -}}
helm.sh/chart: {{ include "lib.chart" . }}
{{ include "lib.selectorLabels" . }}
app.kubernetes.io/version: {{ (.Values.image).tag | default "latest" | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "lib.selectorLabels" -}}
app.kubernetes.io/name: {{ include "lib.name" . }}
app.kubernetes.io/instance: {{ include "lib.instanceName" . }}
{{- end }}

{{- define "lib.environmentVariables" }}
{{- "env:" }}
{{- range $name, $value := . }}
- name: {{ $name }}
  value: {{ $value }}
{{- end }}
{{- end }}

{{- define "lib.serviceAccountName" -}}
{{- if (.Values.serviceAccount).enabled }}
{{- (.Values.serviceAccount).name | default (include "lib.instanceName" .) }}
{{- else }}
{{- "default" }}
{{- end }}
{{- end }}
