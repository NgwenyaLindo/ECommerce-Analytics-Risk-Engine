Checking Shopping Habits and Credit Risks for an Online Store
# 1. What is this project about?
In this project, I wanted to learn how to take messy shopping data from an online store and use it to solve a real business problem: figuring out which customers are safe to deal with and which ones might be a financial risk.

I built a basic data path that does three things:

I used SQL to find and link data tables together.

I used Python to clean up missing information and practice running a basic machine learning model that automatically groups shoppers.

I used Microsoft Excel to make a simple, clean dashboard so a manager can visually see what the groups mean.

# 2. The Tools I Used and Why
MySQL Workbench: This is where the store's data sheets (tables) are kept. I used it to search and grab the exact information I needed.

Jupyter Notebook (Python): I used Python because it has great tools for cleaning up messy spreadsheets and running math formulas that sort things automatically.

Microsoft Excel: I used Excel to build the final charts because it is clean, easy to look at, and great for making reports that regular people can understand.

# 3. Step-by-Step: What I Did
Step 3.1: Linking the Tables (SQL)
The store's data was scattered across four different sheets (Customers, Orders, Items Bought, and Products). I wrote this SQL code to link them all together using customer ID numbers so I could get a single list of names, dates, and prices:

SQL
SELECT 
    c.last_name, 
    c.first_name, 
    o.order_date, 
    p.product_name, 
    c.customer_id,
    oi.item_price, 
    oi.discount_amount, 
    oi.quantity
FROM customers c
INNER JOIN orders o 
    ON c.customer_id = o.customer_id
INNER JOIN order_items oi 
    ON o.order_id = oi.order_id
INNER JOIN products p 
    ON oi.product_id = p.product_id
ORDER BY 
    c.last_name ASC, 
    o.order_date ASC, 
    p.product_name ASC;

Step 3.2: Cleaning Data and Grouping Customers (Python)
Once I had the list, I brought it into Python. I noticed some spots were completely empty, which can break your code. I fixed that by replacing blank spots with 0.

Then, I ran a basic algorithm called K-Means Clustering. This algorithm looks at three things: how recently a customer shopped, how often they buy, and how much money they spend. It automatically split the customers into 3 clusters (groups). Finally, I saved the results as a new spreadsheet.

Python
import pandas as pd
import warnings
from sklearn.preprocessing import StandardScaler
from sklearn.cluster import KMeans

Turn off ugly warning messages to keep the screen clean
warnings.filterwarnings('ignore')

1. Load the spreadsheet file
df = pd.read_csv('customer_rfm_data.csv') 

2. Pick the columns we want to look at
features = df[['recency', 'frequency', 'monetary']]

3. FIXING ERRORS: Change any blank/empty spaces to 0
features = features.fillna(0)

4. Scale the numbers so big dollar amounts don't confuse the system
scaler = StandardScaler()
scaled_features = scaler.fit_transform(features)

5. Group the customers into 3 separate clusters
kmeans = KMeans(n_clusters=3, random_state=42)
df['risk_cluster'] = kmeans.fit_predict(scaled_features)

6. Save this out to a new file so I can open it in Excel
df.to_csv('final_customer_risk_segments.csv', index=False)

Step 3.3: Building the Excel Dashboard
I opened my new Python spreadsheet in Excel and built a simple two-chart report:

Pivot Table: I calculated how many people fell into each cluster and what their average spending looks like.

Pie Chart: Shows the size of each group so you can see if you have more active or inactive users.

Bar Chart: Compares how much money each group spends on average.

Design: I removed the default background gridlines and gray buttons to make it look clean and tidy.

# 4. What the Results Mean
The code split the shoppers into three very clear business groups:

Cluster 0: Regular, Steady Shoppers (Medium Risk)

They shop every now and then and spend average amounts. These are normal, safe buyers.

Cluster 1: Big Spenders (Low Risk)

They shop constantly and spend a lot of money. They are the best, safest customers for the store.

Cluster 2: Inactive Accounts (High Risk)

It has been a very long time since their last purchase, and they spend almost nothing. Extending credit to this group is dangerous because they have likely abandoned the shop.

# 5. Things That Helped Me (Citations)
Since I am learning, I relied on a few resources to help me debug errors:

Google Gemini AI: I used AI to help me outline the project steps, map out the SQL table joins, and fix a NameError I hit in my notebook when Python forgot my variables.

Stack Overflow Forums: Helped me figure out how to write the warnings.filterwarnings('ignore') line to hide annoying background system warnings on my computer.

Scikit-Learn Documentation: Read the user guides to learn why I needed to use a StandardScaler to balance my data numbers before grouping them.