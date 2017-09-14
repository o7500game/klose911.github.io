#!/usr/bin/python
# -*- coding:utf-8 -*-  
#Filename: block_iter.py


blocks = []

while True:
    block = f.read(32)
    if block == '':
        break
    blocks.append(block)

print(blocks) 


blocks = []
for block in iter(partial(f.read, 32),  ''):
    blocks.append(block)

