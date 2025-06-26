*** Settings ***
Library     Collections
Library     SeleniumLibrary
Library     Process
Library     String
Library     OperatingSystem

Library     keywords/python/log_diff.py
Resource    data/login_data.resource
Resource    data/error_data.resource
Resource    keywords/util_keywords.robot
Resource    keywords/auth_keywords.robot
Resource    keywords/db_keywords.robot
Resource    keywords/purchase_keywords.robot
Resource    keywords/errorhandling_keywords.robot
