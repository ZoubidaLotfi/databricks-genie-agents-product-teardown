# Module 1: Prepare your workspace
- [x] GitHub repository created with a defined README file.
- [x] Databricks workspace created. Sample explored and datasets selected.
# Module 2: Understand the product

## Step 2. Explore Databricks Genie as a product
| Question                                    | Beginner-friendly answer                                                                                                                                                                                                                                                                 |
| ------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **1. Who uses Databricks Genie Agents?**    | Business users who understand the company but may not know SQL, such as product, finance, sales, or operations teams. Data analysts or domain experts configure the agent.                                                                                                               |
| **2. What problem does it solve?**          | It lets business users ask questions about company data without waiting for an analyst to create every query or report.                                                                                                                                                                  |
| **3. What data does it need?**              | It needs relevant company tables or views registered in Unity Catalog, plus clear names and descriptions explaining what the data means.                                                                                                                                                 |
| **4. What does a business user ask it?**    | Questions such as: “Which region had the most sales?”, “Why did bookings decrease?”, or “Which customers are most likely to cancel?”                                                                                                                                                     |
| **5. How does it generate an answer?**      | It understands the question, selects the relevant data, creates SQL, runs the SQL, and returns a written answer, table, or visualization.                                                                                                                                                |
| **6. How does it differ from a dashboard?** | A dashboard answers predefined questions through prepared charts. A Genie Agent lets users ask new questions and follow-up questions in normal language.                                                                                                                                 |
| **7. What must the data team configure?**   | The data team must build a clear data catalogue that explains the tables, columns, relationships, business definitions, and metadata the agent can use with business terms.                                                                                                              |
| **8. Where could the product fail?**        | It may misunderstand business terms, select the wrong table, use an incorrect join or filter, misunderstand a date period, or answer a question that the available data cannot support. It can fail if the data is outdated, incomplete, duplicated, poorly cleaned, or badly described. |
Source: [Documentation Databricks](https://docs.databricks.com/aws/en/genie/monitor?utm_source=chatgpt.com "Test and monitor a Genie Agent | Databricks on AWS")


## Step 3. Create a simple product map

- [x] Product map created in `research/product-map.md` and pushed to git

```text
Business user
      ↓
Natural-language question
      ↓
Genie Agent
      ↓
Business definitions and instructions
      ↓
Governed company data
      ↓
Generated SQL
      ↓
Answer, table or visualization
```

## Step 4. Create your glossary

- [x] Glossary `research/glossary.md` created and pushed in git.


# Module 3: Define the user problem

## Step 5. Select one primary user
### Primary persona

**Senior Product Manager at a B2B SaaS company**

The product manager is responsible for:

- Product adoption
    
- Activation
    
- Retention
    
- Feature performance
    
- Customer segmentation
    
- Product health reporting
    

The product manager understands business metrics but does not write advanced SQL.

## Step 6. Describe the current workflow

- [x] Example workflow written in `research/product-brief.md` and committed to git.

```text
1. The product manager notices a change in a dashboard.
2. They want to understand why it happened.
3. The existing dashboard does not provide enough detail.
4. They ask a data analyst for help.
5. The analyst translates the question into SQL.
6. The analyst checks metric definitions and data quality.
7. The product manager receives the answer hours or days later.
8. Follow-up questions restart the process.
```

## Step 7. Write the user frustrations

- Waiting for data analysts
    
- Limited dashboard flexibility
    
- Difficulty asking follow-up questions
    
- Inconsistent metric definitions
    
- Low confidence in AI-generated answers
    
- Difficulty knowing which data was used
    
- Dependence on technical teams
    

## Step 8. Write the job to be done

Use:

>Product Managers often depend on data analysts for follow-up questions, but giving them direct access to enterprise data through AI only creates value if the answers are reliable, understandable, and based on well-governed data.


# Module 4: Define the teardown question

## Step 9. Main question

>  Can Databricks Genie Agents help Product Managers investigate business data faster while still providing reliable answers based on well-governed enterprise data?

Everything you build during the week must help answer this question.

## Step 10. The hypothesis

> Databricks Genie Agents can reduce the time Product Managers spend waiting for analysts, but the reliability of their answers depends on clear business definitions, accurate and updated data, strong metadata, and proper data governance.

## Step 11. Define what you will evaluate

Use five evaluation areas:

| Evaluation area                   | Main question                                                                                                      |
| --------------------------------- | ------------------------------------------------------------------------------------------------------------------ |
| Time to insight                   | Can users reach an answer faster than with dashboards or analyst support?                                          |
| Correctness                       | Are the generated SQL and results accurate?                                                                        |
| Data quality                      | Whether outdated, incomplete, duplicated, or poorly cleaned data affects the answers.                              |
| Business definitions and metadata | Whether clear definitions, table descriptions, and relationships help the agent understand the business correctly. |
| Maintenance                       | How much setup and correction does the data team need to perform?                                                  |

## Step 12. The scope

- SaaS product analytics
    
- Product adoption
    
- Activation
    
- Retention and churn
    
- One simple revenue metric
    
- One AI/BI dashboard as a baseline
    
- One Genie Agent
    
- Data quality and governance
    
- Business definitions and metadata
    
- Simple evaluation of answer speed, reliability, and trust
    

### Checkpoint

You should now be able to explain:

- Who the user is
    
- What problem they have
    
- What Genie promises to solve
    
- What you intend to test
    

---

# Module 5: Define the business scenario
## Step 14. Define the business situation

> A manager at Wanderbricks wants to understand booking performance, cancellations, revenue, and customer satisfaction without waiting for a data analyst.

## Step 15. Define the decisions Genie should support

The Genie Agent should help managers decide where to focus, which problems need attention, and what may be causing changes in booking performance.

| Decision                                  | Example question                                                     |
| ----------------------------------------- | -------------------------------------------------------------------- |
| **Which destinations to prioritize**      | Which destinations generate the most bookings and revenue?           |
| **Where cancellations are a problem**     | Which destinations or properties have the highest cancellation rate? |
| **Which properties need attention**       | Which properties have low ratings or declining bookings?             |
| **How booking performance is changing**   | Are bookings increasing or decreasing over time?                     |
| **Which customer issues matter most**     | Where are poor reviews or support problems concentrated?             |
| **Which areas may need action**           | Which destinations have high demand but poor customer satisfaction?  |
| **What managers should investigate next** | What explains a recent drop in bookings or revenue?                  |

---

# Module 6: Draw the project architecture
A simple architecture diagram can help you explain how Genie Agents work.

![[Genie_Agent architecture diagram.jpg]]
### Checkpoint

You should understand where the agent fits within the broader data product.

The agent is not the entire system. It depends on the data, metrics, metadata and governance underneath it.

---

# Module 7: Set up Databricks

- [x] Databricks Free Edition work space created and tested.

---

# Module 8: Set up GitHub

- [x] GitHub repository now contains the project description and initial folders.

---

# Module 9: Write your open questions

Examples:

- How much semantic configuration is needed?
    
- How does Genie respond to ambiguous terminology?
    
- Can users inspect generated SQL?
    
- How does Genie handle missing information?
    
- How consistent are repeated answers?
    
- How do Genie Agents differ from ordinary chat mode?
    
- Which features are available in Free Edition?
    
- How should agent quality be measured?
    

---

# End-of-day submission

By the end of Monday, submit or complete:

| Deliverable                      |
| -------------------------------- |
| ==`README.md`==                  |
| ==`research/product-brief.md`==  |
| ==`research/research-log.md`==   |
| ==`research/glossary.md`==       |
| ==Product architecture diagram== |
| ==Databricks workspace==         |
| Working SQL schema               |
| Test table and query             |
| ==GitHub repository==            |
| Day 2 dataset plan               |

