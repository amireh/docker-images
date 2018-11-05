#!/usr/bin/python
# -*- coding: utf-8 -*-

# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

ANSIBLE_METADATA = {
  'metadata_version': '1.1',
  'status': ['preview'],
  'supported_by': 'community'
}

DOCUMENTATION = r'''
---
module: mod

short_description: Example module

version_added: "2.5"

description:
  - Example module

options:
  return:
    description: Value to return
    type: number


author:
  - Ahmad Amireh (@amireh)
'''

EXAMPLES = '''
- name: run a function...
  mod:
    return: 1
'''

RETURN = '''
value:
  description: The value you specified
  returned: always
  type: number
  sample: 42
'''

def f():
  return 1
