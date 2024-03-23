---
citekey: {{citekey}}
aliases: [{% if shortTitle %}"{{shortTitle | safe}}"{% else %}"{{title | safe}}"{% endif %}]
title: "{{title}}"
authors: {{authors}}
tags: [literature-note, {% for t in tags %}{{t.tag}}{% if not loop.last %}, {% endif %}{% endfor %}]
year: {{date | format("YYYY")}}
publisher: "{{publicationTitle}}"
doi: {{DOI}}
---

# [{{title}}]({{desktopURI}})

> [!info]+
>{% if bibliography %}**Bibliography:** {{bibliography}}{% endif %}
>
>**Page-no:** {% for annotation in annotations %}{% if loop.first %}{{annotation.pageLabel}}{% endif %}{% endfor %}
>
>{% if hashTags %}**Tags:** {{hashTags}}{% endif %}
>
>{%- for attachment in attachments | filterby("path", "endswith", ".pdf") %}**PDF:** [{{attachment.title}}](file:///{{attachment.path | replace(" ", "%20")}}){%- endfor %}
>
>[**Open in Zotero**]({{desktopURI}})
>[**Open DOI**](https://doi.org/{{DOI}})

> [!abstract]-
> {% if abstractNote %}
> {{abstractNote|replace("\n"," ")}}
> {% endif %}

> [!LINK]
> {%- for attachment in attachments | filterby("path", "endswith", ".pdf") %}
> [{{attachment.title}}](file://{{attachment.path | replace(" ", "%20")}}) {%- endfor -%}.


---

# Notes
> {%- if markdownNotes %}
>{{markdownNotes}}.{%- endif -%}


# Annotations
{% macro calloutHeader(type, color) %}
{%- if type  == "highlight" -%}
<mark style="background-color: {{color}}">Quote</mark>
{%- endif -%}

{%- if type ==  "text" %}
Note
{%- endif %}
{%- endmacro -%}

{% persist "annotations" %}
{% set newAnnotations =  annotations | filterby("date", "dateafter", lastImportDate) %}
{% if newAnnotations.length > 0 %}

### Imported: {{importDate | format("YYYY-MM-DD h:mm a")}}

{% for a in newAnnotations %}
{{calloutHeader(a.type, a.color)}}
> {{a.annotatedText}}
{% endfor %}
{% endif %}
{% endpersist %}
