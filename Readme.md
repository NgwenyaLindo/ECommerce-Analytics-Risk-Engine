Checking Shopping Habits and Credit Risks for an Online Store
1. Summary of the Project
This project builds a step-by-step data system that takes messy, scattered lists from an online store's database and turns them into clear business insights.

Using SQL, we pull separate spreadsheets (like lists of customers, orders, and items bought) and blend them into one master list. Then, using Python, we run a sorting model that automatically groups customers into three clear risk levels based on how often they shop, how recently they visited, and how much money they spent. This helps a business know exactly which customers are safe to work with and which ones might be a financial risk.

2. The Tools and How Data Moves
The project is divided into two simple steps:

The Data Storage Layer: Hosted inside MySQL, where all the store's everyday shopping records are safely kept in organized tables.

The Smart Sorting Layer: Built inside a Jupyter Notebook (Python), where we clean the data, fix missing information, and run our automatic grouping model.

3. The Code We Used
Step 3.1: Combining Separate Sheets (SQL)
This code reaches into the database, links four different sheets together using customer ID numbers, and spits out a clean table showing everyone's shopping history.

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
Step 3.2: Grouping the Customers (Python)
This script reads our store data, immediately changes any blank spaces or missing math values to 0 so the computer doesn't crash, and splits the shoppers into three groups.

Python
import pandas as pd
import warnings
from sklearn.preprocessing import StandardScaler
from sklearn.cluster import KMeans

# Hide system warnings to keep our report clean
warnings.filterwarnings('ignore')

# 1. Load the spreadsheet we got from SQL
df = pd.read_csv('customer_rfm_data.csv') 

# 2. Grab the columns for days since last purchase, total orders, and total spend
features = df[['recency', 'frequency', 'monetary']]

# 3. FIX ERRORS: Change any blank or empty spots to 0
features = features.fillna(0)

# 4. Balance the numbers so large currency amounts don't confuse the model
scaler = StandardScaler()
scaled_features = scaler.fit_transform(features)

# 5. Run the automatic grouping model (K-Means) to make 3 groups
kmeans = KMeans(n_clusters=3, random_state=42)
df['risk_group'] = kmeans.fit_predict(scaled_features)

# 6. Print out the mathematical averages for our 3 groups
cluster_summary = df.groupby('risk_group')[['recency', 'frequency', 'monetary']].mean()
print(cluster_summary)
4. What the Customer Groups Mean for Business Risk
Our sorting model naturally separates the store's buyers into three specific groups:

Group 0: Low Risk / Big Spenders

What the math shows: They shop very frequently, buy things constantly, and spend a lot of money.

What it means for risk: These are the safest, most valuable customers. The only business risk here is putting "all your eggs in one basket" if the store relies too heavily on just a few of these people.

Group 1: Medium Risk / Regular Shoppers

What the math shows: They shop occasionally, spend average amounts, and visit every now and then.

What it means for risk: Safe, normal buyers. They have a predictable, low-risk profile and represent great opportunities for standard marketing updates.

Group 2: High Risk / Inactive or Churned

What the math shows: It has been a very long time since their last purchase, and they have barely spent any money.

What it means for risk: These accounts are dangerous for credit. They have either abandoned the shop completely or represent a high risk of failing to pay their bills. The store should limit credit options for this group.

5. Citations, Research Tools, and Acknowledgments
To build this project up to professional standards, a modern research and troubleshooting workflow was used, combining artificial intelligence with global developer forums.

Artificial Intelligence (AI) Planning Citation
Source: Gemini Large Language Model (Google AI).

Usage Acknowledgments: AI was explicitly used as a research co-pilot to outline the data pipeline steps, design the math structures, and write the initial drafts of the multi-table SQL joins. Additionally, AI was heavily relied upon for debugging assistance—specifically for identifying why the machine learning model rejected blank fields, which led to using the fillna(0) code fix.

Developer Forums and Library Documentation Citations
Stack Overflow & Windows MKL Threads: Cited for troubleshooting a specific memory warning (UserWarning: KMeans is known to have a memory leak on Windows with MKL). Forum discussions provided the solution to suppress background Windows warnings using Python's warnings.filterwarnings('ignore') library, ensuring a clean final presentation.

Scikit-Learn Official User Guides: Referenced to understand how spatial distance sorting algorithms handle columns with different number scales (like comparing single-digit order counts to large dollar amounts). This research guided the use of the StandardScaler tool to format the numbers fairly before grouping them.