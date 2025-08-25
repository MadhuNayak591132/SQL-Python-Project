#!/usr/bin/env python
# coding: utf-8

# In[1]:


import kaggle


# In[2]:


#read data from the file and handle null values
import pandas as pd
df = pd.read_csv(r"C:\Users\nayak\Downloads\orders.csv\orders.csv",na_values=['Not Available', 'unknown'])
df['Ship Mode'].unique()


# In[4]:


#rename column names ..make them lower case and replace space with underscore
df.columns = df.columns.str.lower()
df.columns = df.columns.str.replace(' ','_')
df.head(5)


# In[5]:


#derive new columns discount, sale price and profit
df['discount'] = df['list_price']*df['discount_percent']*.01
df['sale_price'] = df['list_price']-df['discount']
df['profit'] = df['sale_price'] - df['cost_price']


# In[6]:


#convert order date from object data type to datetime
df['order_date'] = pd.to_datetime(df['order_date'],format="%Y-%m-%d")


# In[7]:


#Drop cost price list price and discount percent
df.drop(columns=['list_price','cost_price','discount_percent'],inplace=True)


# In[8]:


df.head(5)


# In[9]:


#load the data into sql server using replace option
from sqlalchemy import create_engine

# connect only to MySQL server (no db yet)
engine = create_engine("mysql+pymysql://root:@localhost:3306/") 

#creating the db name orders
with engine.connect() as conn:
    conn.execute("CREATE DATABASE IF NOT EXISTS orders;")
    print('db created successfully')
    
# now connecting to the new database
engine = create_engine("mysql+pymysql://root:@localhost:3306/orders")


# In[11]:


#load the data into sql server using append option
df.to_sql(
    "orders",
    con=engine,
    if_exists="append",   # or "replace"
    index=False
)











