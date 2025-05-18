# 📄 Gdańsk City Hall – Request & Complaint Analytics System

A data-driven analytical system designed to support Gdańsk City Hall in monitoring and improving their core public service processes — **document request handling** and **public complaint management**.

## 🏛️ Project Purpose

The City Hall aims to ensure **faster and more efficient service for citizens**, with a strategic goal to reduce the **average request wait time by 3% annually**. Our project supports this goal by providing insights into:

- Request and complaint trends
- Staff performance
- Peak activity periods
- Request processing efficiency

## 📊 Business Processes Analyzed

### 1. Requesting a Document

Citizens can request documents such as ID cards or vehicle registrations either:

- ✅ Online (via the City Hall website)
- 🏢 In-person (at the facility)

These requests are processed through several stages: **submission → scheduling → processing → completion**.

#### 🔍 Key Analytical Questions

- What is the average wait time this month vs. last month?
- Which document types have the longest/shortest wait times?
- Are online requests processed faster than in-person ones?
- What percentage of requests meet the target completion time?
- How does performance vary by official and by document type?

### 2. Managing Public Complaints

Citizens submit complaints regarding public services (e.g. noise, road issues). Complaints are:

- Logged ➡️ Categorized ➡️ Assigned ➡️ Reviewed ➡️ Resolved

#### 🔍 Key Analytical Questions

- What is the average complaint resolution time this month?
- Which categories are most frequent or take the longest to resolve?
- Do online complaints get resolved faster?
- On which days are most complaints submitted?
- What percentage of complaints are resolved within 30 days?

---

## 📁 Data Sources

### 🧮 Database Tables

#### `OFFICIAL`
| Attribute         | Type      | Description                                    |
|------------------|-----------|------------------------------------------------|
| `official_ID`     | string(8) | Unique staff ID (PK)                          |
| `department`      | string(50)| Name of department                           |
| `name1`, `name2`  | string(30)| First and second name                         |
| `surname`         | string(30)| Last name                                     |
| `email`           | string(50)| Contact email                                 |

#### `CITIZEN`
| Attribute        | Type        | Description                          |
|------------------|-------------|--------------------------------------|
| `PESEL`           | string(11)  | Unique citizen ID (PK)               |
| `name1`, `name2`  | string(30)  | First and second name               |
| `surname`         | string(30)  | Last name                            |
| `birth_date`      | date        | Birth date (DD-MM-YYYY)              |

#### `REQUEST`
| Attribute                 | Type         | Description                                   |
|---------------------------|--------------|-----------------------------------------------|
| `request_ID`              | string(10)   | Unique request ID (PK)                        |
| `official_ID`             | string(10)   | FK to processing staff                        |
| `PESEL`                   | string(11)   | FK to requesting citizen                      |
| `document_name`           | string(30)   | Requested document type                       |
| `submission_date`         | date         | Date submitted                                |
| `processing_start_date`   | date         | Date processing started                       |
| `estimated_completion_date`| date        | Estimated finish date                         |
| `completion_date`         | date         | Actual completion date                        |
| `status`                  | string(10)   | Current status                                |
| `submission_method`       | string(10)   | Online / In-person                            |

---

### 📄 CSV Files

#### Document Request Reasons
| Column | Description                                            |
|--------|--------------------------------------------------------|
| A      | Request ID                                             |
| B      | Is first-time request (Boolean)                        |
| C      | Old document expired (Boolean)                         |
| D      | Update personal data (Boolean)                         |
| E      | Other reason (Text)                                    |

#### Realization Delay Reasons
| Column | Description                                            |
|--------|--------------------------------------------------------|
| A      | Request ID                                             |
| B      | Citizen provided full data (Boolean)                   |
| C      | Missing data (if B = 0)                                |
| D      | High demand / queue (Boolean)                          |
| E      | Other reason (Text)                                    |

---

## 🔗 Relationships Between Data

- **CITIZEN ↔ REQUEST** (One-to-Many): One citizen may have multiple document requests.
- **OFFICIAL ↔ REQUEST** (One-to-Many): Each request is processed by one official.
- **REQUEST ↔ Reason Files** (One-to-One): Each request has one record in the reason CSV files.

---

## ❓ Example Analytical Scenarios

### 📈 Demand Tracking
- Total document requests this vs. last month
- Online vs. in-person requests per month
- Peaks in submission days or times
- Most requested document types

### ⏱️ Efficiency Analysis
- Average processing time by document type or official
- Wait time difference: online vs. in-person
- Requests exceeding estimated wait time
- Delay reasons by document type

### 🧑‍💼 Staff Performance
- Workload per official
- Completion time comparisons between officials
- Efficiency during peak vs. off-peak periods

---

## 💡 Additional Insights (Future Enhancements)

- Compare foreign vs. native citizen service times (requires ethnicity data)
- Collect post-service feedback from citizens (requires feedback system)

---

## 📐 KPIs & Business Goals

- 📉 Reduce average wait time by **0.25% monthly**
- 🕒 Reduce request processing time by **0.25% monthly**
- ✅ Maintain/increase number of processed requests
- 🎯 Achieve high percentage of requests resolved within estimated time

---

## 🛠️ Technologies Used

- SQL-based relational database
- CSV data integration
- Analytics via Python / BI tools (Power BI / Tableau recommended)
- Potential for machine learning-driven trend detection

---

## 📍 Summary

This project provides Gdańsk City Hall with the analytical backbone necessary to monitor service quality, allocate staff efficiently, and make data-informed policy decisions — all to ensure faster, smarter public service.

---

