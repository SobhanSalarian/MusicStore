import mysql.connector
import pandas as pd
config = {
    'user': 'root',
    'password': 'Sobh@n_123',
    'host': 'localhost',  # e.g., 'localhost' or '127.0.0.1'
    'database': 'chinook',
}

# Establish connection
cnx = mysql.connector.connect(**config)

# Create a cursor
cursor = cnx.cursor()

# Query to get all table names
cursor.execute("SHOW TABLES")
tables = cursor.fetchall()

# Fetch each table into a dataframe
dataframes = {}
for (table_name,) in tables:
    query = f"SELECT * FROM {table_name}"
    dataframes[table_name] = pd.read_sql(query, cnx)

# Close cursor and connection
cursor.close()
cnx.close()

track = dataframes["track"]

mediatype = dataframes["mediatype"]

invoiceline = dataframes["invoiceline"]

genre = dataframes["genre"]

employee = dataframes["employee"]

customer = dataframes["customer"]

albums = dataframes["albums"]

invoice = dataframes["invoice"]


print("done")


