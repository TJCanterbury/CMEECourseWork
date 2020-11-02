#!/usr/bin/env python3
# Filename: using_name.py
""" demonstrates aspects of python programs """
if __name__ == '__main__':
    print('THis program is being run by itself')
else:
    print('THis program is being imported from another module')

print("This module's name is:" + __name__)