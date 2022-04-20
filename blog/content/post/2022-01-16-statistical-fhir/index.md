---
title: Statistical FHIR
author: 'Gavin'
date: '2022-01-16'
slug: statistical-fhir
categories: ["fhir","statistics"]
tags: []
---

FHIR concerns itself principally with recording healthcare system events and less about modeling.
Every event recorded by a FHIR system may be modeled to predict its future behavior,
and the estimates of the modeled distribution parameters conveniently stored
in the FHIR schema. It does not appear to be prescribed or suggested how to to this.

One idea is to abstract away the modeled quantity e.g. duration in an [FHIR Task](https://www.hl7.org/fhir/task.html) 
and replace this by the parameters of the distribution of task time (mean and standard deviation if Gaussian), and store these instead of the realized instance. 
This would probably create confusion as to whether a resource is a recording of an event or is template resource recording parameter estimates for a population.

Another idea would be to generalize the FHIR methods for recording [clinical observations](https://www.hl7.org/fhir/observation.html) to workflow event 
quantities such as operation duration. This has the advantage of re-using 
clinical coding structure, and would generalize the FHIR experimentation workflow.
There is an [observation statistics OperationDefinition](https://www.hl7.org/fhir/operation-observation-stats.html)
along with a [basic list of statistics](https://www.hl7.org/fhir/valueset-observation-statistics.html)
which may be suitably extended to provide the distribution parameters of any 
observation (insofar as a model parameter estimate is a statistic).

There are many examples of storing healthcare system information as well as modeling artifacts 
in an FHIR schema, albeit mainly directed to clinical problems rather than the scheduling.

- [KETOS](https://pubmed.ncbi.nlm.nih.gov/31581246/) is clinical decision support system using FHIR which **implements a tool for researchers allowing them to perform statistical analyses and deploy resulting models in a secure environment.**
- [FHIR Data for Statistical Analysis: Design and Implementation Study](https://pubmed.ncbi.nlm.nih.gov/33792554/) modeled **approximately 35.5 million FHIR resources, including "Patient," "Encounter," "Condition" (diagnoses specified using International Classification of Diseases codes), "Procedure," and "Observation" (laboratory test results)** with the above KETOS FHIR tool.
- [NGS Quality Reporting (NGS-QR)](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC8116992/) uses an 
FHIR profile for genomic data, stored in an FHIR server and visualized the result in an R-Shiny app.






