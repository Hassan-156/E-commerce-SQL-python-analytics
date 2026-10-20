import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import scipy.stats as stats
import seaborn as sns
from sqlalchemy import create_engine
import urllib 

# 1. establishing connection to the database
params = urllib.parse.quote_plus(
    r'DRIVER={ODBC Driver 17 for SQL Server};'
    r'SERVER=localhost\SQLEXPRESS;'
    r'DATABASE=E_CommerceDB;'
    r'Trusted_Connection=yes;'
 )

engine = create_engine(f'mssql+pyodbc:///?odbc_connect={params}')
print("All libraries imported and database connection established successfully.")


# pulling from the E_Commerce database.
# query = "SELECT TOP 10 * FROM vw_OrderSummary;" 
# df = pd.read_sql(query, con=engine)
# print("n\Data from E_Commerce database pulled successfully.")
# print(f"Total row retrieved in sample: {len(df)}")
# print("\nFirst few rows of Order summary:")
# print(df.head())  # Display the first few rows of the DataFrame


# print("Data pulled from the database successfully.")

# 2. Pull Order totals and statuses from my SQL view for ANOVA analysis 
# sql_query = " SELECT OrderStatus, OrderTotal FROM vw_OrderSummary WHERE OrderTotal IS NOT NULL" 
# df = pd.read_sql(sql_query, con=engine)

# print(f"Loaded {len(df)} rows for ANOVA analysis.")
# print(df['OrderStatus'].value_counts()) 

# # 3. separate OrderTotals into distinct groups based on OrderStatus
# groups = []
# status_list = df['OrderStatus'].unique()

# for status in status_list:
#     group_data = df[df['OrderStatus'] == status]['OrderTotal']
#     groups.append(group_data)
#     print(f"Mean Order Total for '{status}': ${group_data.mean():.2f}") 

# # 4. Run one-way ANOVA using SciPy
# f_stat, p_value = stats.f_oneway(*groups)

# print("n\--- ANOVA Statistical Results ---")
# print(f"f-Statistics: {f_stat:.4f}")
# print(f"p-Value: {p_value:.4e}") 

# # 5. Business verdict 
# if p_value <0.05:
#     print(
#         "Result: Statistically Significant! (p_value <0.05)  At least one order"
#         "status has a significantly different average order total"
#     )
# else:
#     print(
#         "Result: Not significant. Average order totals  do not vary significantly"
#         "across order statuses."
#     )

# 1. multi-table merging (pd.merge) and data exploration
# pull data from the Customers and Orders tables for further analysis
# df_customers = pd.read_sql("SELECT * FROM Customers", con=engine)
# df_orders = pd.read_sql("SELECT * FROM Orders", con=engine)

# # Merge them together on CustomerID (like a SQL inner join) 
# df_merged = pd.merge(df_orders, df_customers, on= 'CustomerID', how='inner')

# # print("merged dataframe preview:")
# print(df_merged[["OrderID", "FirstName", "LastName", "TotalAmount"]].head())

# 2. Advanced grouping & aggregation (groupby + agg) and data exploration
# Want to know who your top customers are by total lifetime value (LTV)? Pandas makes multi-metric aggregation effortless:

df_customers = pd.read_sql("SELECT * FROM Customers", con=engine)
df_orders = pd.read_sql("SELECT * FROM Orders", con=engine)

df_merged = pd.merge(df_orders, df_customers, on="CustomerID", how="inner")
print(f"Successfully merged tables! Total rows in df_merged: {len(df_merged)}") 
# group by customer  and compute multi stats at once.
customer_summary = (
    df_merged.groupby(["CustomerID", "FirstName", "LastName"])
    .agg(
        total_spent = ("TotalAmount", "sum"),
        order_count = ("OrderID", "count"),
        avg_order_value = ("TotalAmount", "mean"), 
    )
    .reset_index()
) 

top_customers = customer_summary.sort_values(by="total_spent", ascending=False) 

print("\n--- Top 5 customers by Lifetime Spent") 
print(top_customers.head()) 


# Set clean visual theme
sns.set_theme(style="whitegrid")

# Create figure window
plt.figure(figsize=(10, 6))
top_5 = top_customers.head(5)

# Create a clean bar chart
ax = sns.barplot(x="FirstName", y="total_spent", data=top_5, palette="Blues_r")

# Add titles and labels
plt.title(
    "Top 5 E-Commerce Customers by Lifetime Spend",
    fontsize=14,
    fontweight="bold",
    pad=15,
)
plt.xlabel("Customer First Name", fontsize=12)
plt.ylabel("Total Lifetime Spend ($)", fontsize=12)

# Annotate exact dollar values on top of each bar
for p in ax.patches:
  ax.annotate(
      f"${p.get_height():,.2f}",
      (p.get_x() + p.get_width() / 2.0, p.get_height()),
      ha="center",
      va="bottom",
      fontsize=10,
      fontweight="bold",
      color="darkblue",
      xytext=(0, 5),
      textcoords="offset points",
  )

plt.tight_layout()
plt.show()

# print(df_customers.head(10))
# print(df_customers.info())
# print(df_customers.describe())
# print(df_customers.shape)
# print(df_customers.dtypes)





