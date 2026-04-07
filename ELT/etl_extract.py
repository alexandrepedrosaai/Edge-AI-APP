import requests
import csv

def extract_from_api():
    response = requests.get("https://api.example.com/sensors")
    return response.json()

def extract_from_csv(path="data/sensors.csv"):
    with open(path, newline='') as f:
        reader = csv.DictReader(f)
        return [row for row in reader]

def extract_all():
    api_data = extract_from_api()
    csv_data = extract_from_csv()
    return api_data + csv_data
