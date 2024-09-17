from flask import Flask, request, jsonify
import psycopg2
from os import getenv

app = Flask(__name__)

# PostgreSQL connection parameters
conn = psycopg2.connect(
    host=getenv("POSTGRES_SERVICE"),
    database=getenv("POSTGRES_DB"),
    user=getenv("POSTGRES_USER"),
    password=getenv("POSTGRES_PASSWORD")
)

# Function to execute queries
def execute_query(query, params=None):
    with conn.cursor() as cursor:
        cursor.execute(query, params)
        conn.commit()

# Function to fetch data
def fetch_query(query, params=None):
    with conn.cursor() as cursor:
        cursor.execute(query, params)
        return cursor.fetchall()

# Create the table if not exists
@app.route('/create_table')
def create_table():
    execute_query("""
        CREATE TABLE IF NOT EXISTS items (
            id SERIAL PRIMARY KEY,
            name VARCHAR(80) NOT NULL,
            description TEXT
        )
    """)

# Create (POST)
@app.route('/items', methods=['POST'])
def create_item():
    data = request.json
    if 'name' not in data:
        return jsonify({'error': 'Name is required'}), 400
    name = data['name']
    description = data.get('description', '')

    execute_query("INSERT INTO items (name, description) VALUES (%s, %s)", (name, description))
    return jsonify({'message': 'Item created successfully'}), 201

# Read all items (GET)
@app.route('/items', methods=['GET'])
def get_items():
    rows = fetch_query("SELECT id, name, description FROM items")
    items = [{'id': row[0], 'name': row[1], 'description': row[2]} for row in rows]
    return jsonify(items)

# Read single item (GET)
@app.route('/items/<int:id>', methods=['GET'])
def get_item(id):
    rows = fetch_query("SELECT id, name, description FROM items WHERE id = %s", (id,))
    if rows:
        row = rows[0]
        return jsonify({'id': row[0], 'name': row[1], 'description': row[2]})
    return jsonify({'error': 'Item not found'}), 404

# Update (PUT)
@app.route('/items/<int:id>', methods=['PUT'])
def update_item(id):
    data = request.json
    if 'name' not in data:
        return jsonify({'error': 'Name is required'}), 400
    name = data['name']
    description = data.get('description', '')

    execute_query("UPDATE items SET name = %s, description = %s WHERE id = %s", (name, description, id))
    return jsonify({'message': 'Item updated successfully'})

# Delete (DELETE)
@app.route('/items/<int:id>', methods=['DELETE'])
def delete_item(id):
    execute_query("DELETE FROM items WHERE id = %s", (id,))
    return jsonify({'message': 'Item deleted successfully'})

if __name__ == '__main__':
    app.run(debug=True, port=5000, host="0.0.0.0")
