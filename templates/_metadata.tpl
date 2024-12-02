{{- define "lib.metadata" }}
metadata:
  name: {{ include "lib.name" . }}
  namespace: {{ .Values.namespace | default .Release.Namespace }}
  labels:
    {{- include "lib.labels" . | nindent 4 }}
{{- end }}
