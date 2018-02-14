# sqlite3-secure
sqlite3 encrypt base on wxsqlite  
[详细描述-blog](http://www.cnblogs.com/luweimy/p/4214663.html)

#### DEMO
```
//
//  main.cpp
//  sqlite3
//
//  Created by Luwei on 15/1/9.
//  Copyright (c) 2015年 Luwei. All rights reserved.
//

#include <iostream>

#include "sqlite3-secure/sqlite3.h"

void db_open(sqlite3 **ppDb, const std::string &path);
void db_close(sqlite3 *pDb);
void db_encrypt(sqlite3 *pDb, const std::string &password);

// DEMO
void db_createtable(sqlite3 *pDb);
void db_insert(sqlite3 *pDb);
void db_delete(sqlite3 *pDb);
void db_update(sqlite3 *pDb);
void db_select(sqlite3 *pDb);

int main()
{
    std::string path = "/Users/etime/Documents/db";
    std::string password = "hello,world";
    sqlite3 *pDb = nullptr;
    
    try {
        
        db_open(&pDb, path);
        db_encrypt(pDb, password);
        
        db_createtable(pDb);
        db_insert(pDb);
        db_delete(pDb);
        db_update(pDb);
        db_select(pDb);
        
        db_close(pDb);
    }
    catch (const char *what) {
        printf("[DB Error]: %s\n", what);
        sqlite3_close(pDb);
        return -1;
    }
    return 0;
}

void db_open(sqlite3 **ppDb, const std::string &path) {
    int c = SQLITE_OK;
    if (path.empty())
        c = sqlite3_open(":memory", ppDb);
    else
        c = sqlite3_open(path.c_str(), ppDb);
    
    if (c != SQLITE_OK)
        throw sqlite3_errmsg(*ppDb);
}

void db_close(sqlite3 *pDb) {
    int c = sqlite3_close(pDb);
    
    if (c != SQLITE_OK)
        throw sqlite3_errmsg(pDb);
}

void db_encrypt(sqlite3 *pDb, const std::string &password) {
    int c = SQLITE_OK;
    if (password.empty())
        return;
    else
        c = sqlite3_key(pDb, password.c_str(), (int)password.length());
    
    if (c != SQLITE_OK)
        throw sqlite3_errmsg(pDb);
    
    // sqlite3_rekey()
}

void db_createtable(sqlite3 *pDb) {
    const char *sql =   "CREATE TABLE IF NOT EXISTS user"
                        "([id] INTEGER PRIMARY KEY, name TEXT)";
    
    int c = sqlite3_exec(pDb, sql, nullptr, nullptr, nullptr);
   
    if (c != SQLITE_OK)
        throw sqlite3_errmsg(pDb);
}

void db_insert(sqlite3 *pDb) {
    const char *sql = "INSERT INTO user values(NULL, 'luweimy')";

    int c = sqlite3_exec(pDb, sql, nullptr, nullptr, nullptr);
    
    if (c != SQLITE_OK)
        throw sqlite3_errmsg(pDb);
    
    int count = sqlite3_changes(pDb);
    printf("[DB Log]: <INSERT> %d item changes\n", count);
}

void db_delete(sqlite3 *pDb) {
    const char *sql = "DELETE FROM user WHERE id=2";
    
    int c = sqlite3_exec(pDb, sql, nullptr, nullptr, nullptr);
    
    if (c != SQLITE_OK)
        throw sqlite3_errmsg(pDb);
    
    int count = sqlite3_changes(pDb);
    printf("[DB Log]: <DELETE> %d item changes\n", count);
}

void db_update(sqlite3 *pDb) {
    const char *sql = "UPDATE user SET name=\"**luweimy**\" WHERE id=1";
    
    int c = sqlite3_exec(pDb, sql, nullptr, nullptr, nullptr);
    
    if (c != SQLITE_OK)
        throw sqlite3_errmsg(pDb);
    
    int count = sqlite3_changes(pDb);
    printf("[DB Log]: <UPADTE> %d item changes\n", count);
}

void db_select(sqlite3 *pDb) {
    const char *sql = "SELECT * FROM user";
    
    sqlite3_stmt *pStmt = nullptr;
    int c = sqlite3_prepare_v2(pDb, sql, (int)strlen(sql), &pStmt, nullptr);
    if (c != SQLITE_OK)
        throw sqlite3_errmsg(pDb);
    
    c = sqlite3_step(pStmt);
    if (c != SQLITE_ROW && c != SQLITE_DONE)
        throw sqlite3_errmsg(pDb);
    
    int colnum = sqlite3_column_count(pStmt);
    
    while (c == SQLITE_ROW) {
        for (int i = 0; i < colnum; i++) {
            printf("%s \t \t", sqlite3_column_text(pStmt, i));
        }
        printf("\n");
        c = sqlite3_step(pStmt);
    }
    
    if (c != SQLITE_DONE)
        throw sqlite3_errmsg(pDb);

    c = sqlite3_finalize(pStmt);
    if (c != SQLITE_OK)
        throw sqlite3_errmsg(pDb);
}
```
