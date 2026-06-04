class QueryBuilder {
    constructor(conn) {
        this.conn = conn;
        this.tableName = '';
        this.conditions = [];
        this.allowedConditions = [];
        this.columns = ['*'];
    }

    table(tableName) {
        this.tableName = tableName;
        return this;
    }

    where(conditions = []) {
        if (!Array.isArray(conditions)) {
            conditions = [conditions];
        }

        // Set default operator to '=' if not provided
        this.conditions = conditions.map(condition => ({
            field: condition.field,
            operator: condition.operator || '=',
            value: condition.value
        }));
        return this;
    }

    allow(allowedConditions = []) {
        this.allowedConditions = allowedConditions;
        return this;
    }

    select(columns = ['*']) {
        this.columns = columns;
        return this;
    }

    validateCondition(condition) {
        if (!this.allowedConditions.includes(condition)) {
            throw new Error(`Invalid condition: ${condition}`);
        }
        return this.conn.escapeId(condition);
    }

    async execute() {
        if (!this.tableName) {
            throw new Error('Table name is not specified.');
        }

        // Validate and build the WHERE clause
        const whereClauses = [];
        const values = [];
        for (let { field, operator, value } of this.conditions) {
            const escapedCondition = this.validateCondition(field);
            whereClauses.push(`${escapedCondition} ${operator} ?`);
            values.push(value);
        }
        const whereClause = whereClauses.length > 0 ? ' WHERE ' + whereClauses.join(' AND ') : '';

        // Escape column names for SELECT statement
        const columns = this.columns.includes('*') ? '*' : this.columns.map(column => this.conn.escapeId(column)).join(', ');

        // Build the query
        const query = `SELECT ${columns} FROM ${this.conn.escapeId(this.tableName)}${whereClause}`;
        
        // Execute the query
        const result = await this.conn.query(query, values);
        return result;
    }
}

function getActivity(conn) {
    return new QueryBuilder(conn);
}

module.exports = getActivity;
