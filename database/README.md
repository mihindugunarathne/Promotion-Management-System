# Database Export Instructions

This directory contains the MySQL database dump for the Promotion Management System.

## Exporting the Database

To export your MySQL database, use the `mysqldump` command. Follow these steps:

### Option 1: Using Command Line (Recommended)

1. Open PowerShell or Command Prompt
2. Navigate to this directory or run from project root
3. Run the export command:

```bash
# Windows (PowerShell)
mysqldump -u YOUR_USERNAME -p promotion_db > database/promotion_db.sql

# Or with full path to MySQL bin directory if not in PATH
"C:\Program Files\MySQL\MySQL Server 8.0\bin\mysqldump.exe" -u YOUR_USERNAME -p promotion_db > database/promotion_db.sql
```

**Replace:**

- `YOUR_USERNAME` with your MySQL username (e.g., `root`)
- You will be prompted for your MySQL password

### Option 2: Using MySQL Workbench

1. Open MySQL Workbench
2. Connect to your MySQL server
3. Go to **Server** → **Data Export**
4. Select the `promotion_db` database
5. Choose export options:
   - Export to Self-Contained File
   - Include Create Schema
   - Export to: `database/promotion_db.sql`
6. Click **Start Export**

## Importing the Database

To import the database on a new system:

```bash
# Create the database first
mysql -u YOUR_USERNAME -p -e "CREATE DATABASE promotion_db;"

# Import the SQL file
mysql -u YOUR_USERNAME -p promotion_db < database/promotion_db.sql
```

Or using MySQL Workbench:

1. Open MySQL Workbench
2. Connect to your MySQL server
3. Go to **Server** → **Data Import**
4. Select **Import from Self-Contained File**
5. Choose `database/promotion_db.sql`
6. Select default target schema: `promotion_db`
7. Click **Start Import**

## Database Schema

The database contains the following tables:

- **users**: User accounts with authentication and role information
- **promotions**: Promotion records with banner images

## Default Data

The database includes default users (created by DataInitializer):

- **Admin User**: username=`admin`, password=`admin123`, role=ADMIN
- **Regular User**: username=`user`, password=`user123`, role=USER

**Note**: These are default credentials for development. Change them in production!
