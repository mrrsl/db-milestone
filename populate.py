import csv
import os

def generate_insert_statements(file_path, table_name):
    """
    Reads a CSV file from the given path and generates a list of PostgreSQL INSERT statements
    using the CSV column names as PostgreSQL column names.

    Args:
        file_path (str): The path to the CSV file.
        table_name (str): The name of the PostgreSQL table.

    Returns:
        list: A list of INSERT statements as strings.
    """
    insert_statements = []
    
    with open(file_path, 'r', newline='', encoding='utf-8') as csvfile:
        reader = csv.reader(csvfile)
        headers = next(reader)  # Get column names from first row
        
        for row in reader:
            columns = ', '.join(headers)
            
            # Prepare values, quoting strings and handling None/empty values
            values = []
            for value in row:
                if value.strip() == '' or value.lower() == 'null':
                    values.append('NULL')
                else:
                    # Escape single quotes by doubling them
                    escaped_value = value.replace("'", "''")
                    values.append(f"'{escaped_value}'")
            
            values_str = ', '.join(values)
            
            # Create INSERT statement
            insert_stmt = f"INSERT INTO {table_name} ({columns}) VALUES ({values_str});"
            insert_statements.append(insert_stmt)
    
    return insert_statements

def main():

    table_order = ['users', 'terms', 'sets', 'students', 'courses', 'sections', 'lab_assignments', 'lab_events', 'progress', 'progress_change_log']
    seed_file = 'seed_data.sql'

    truncate_cmd = f"-- Clear out tables\nTRUNCATE {','.join(table_order)};\n"
    
    print('Writing seed_data.sql')

    try:
        os.remove(seed_file)
    except:
        print('Creating new seed file')
    
    with open(seed_file, mode='a', newline='', encoding='utf-8') as script:

        script.write(truncate_cmd)

        for entity in table_order:

            print(f"Writing inserts for {entity}")
            inserts = generate_insert_statements(f"data/{entity}.csv", entity)

            script.write(f"-- {entity}\n")

            for statement in inserts:
                script.write(statement + '\n');

            script.write('\n')

    print ('Finished writing')

main()