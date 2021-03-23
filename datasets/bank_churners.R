library(tidyverse)
library(here)

# data taken from: https://www.kaggle.com/sakshigoyal7/credit-card-customers

#CLIENTNUM
#Client number. Unique identifier for the customer holding the account
#
#Attrition_Flag
#Internal event (customer activity) variable - if the account is closed then "Attrited Customer" else "Existing Customer"
#
#Customer_Age
#Demographic variable - Customer's Age in Years
#
#Gender
#Demographic variable - M=Male, F=Female
#
#Dependent_count
#Demographic variable - Number of dependents
#
#Education_Level
#Demographic variable - Educational Qualification of the account holder (example: high school, college graduate, etc.)
#
#Marital_Status
#Demographic variable - Married, Single, Divorced, Unknown
#
#Income_Category
#Demographic variable - Annual Income Category of the account holder (< $40K, $40K - 60K, $60K - $80K, $80K-$120K, > $120K, Unknown)
#
#Card_Category
#Product Variable - Type of Card (Blue, Silver, Gold, Platinum)
#
#Months_on_book
#Period of relationship with bank
#
#Total_Relationship_Count
#Total no. of products held by the customer
#
#Months_Inactive_12_mon
#No. of months inactive in the last 12 months
#
#Contacts_Count_12_mon
#No. of Contacts in the last 12 months
#
#Credit_Limit
#Credit Limit on the Credit Card
#
#Total_Revolving_Bal
#Total Revolving Balance on the Credit Card
#
#Avg_Open_To_Buy
#Open to Buy Credit Line (Average of last 12 months)
#
#Total_Amt_Chng_Q4_Q1
#Change in Transaction Amount (Q4 over Q1)
#
#Total_Trans_Amt
#Total Transaction Amount (Last 12 months)
#
#Total_Trans_Ct
#Total Transaction Count (Last 12 months)
#
#Total_Ct_Chng_Q4_Q1
#Change in Transaction Count (Q4 over Q1)
#
#Avg_Utilization_Ratio
#Average Card Utilization Ratio


# temporarily downloaded to desktop
data <- read_csv("~/Desktop/BankChurners.csv") %>%
  select(-22, -23)

write_csv(data, here("datasets", "bank_churners.csv"))
