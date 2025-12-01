import hashlib

def to_hash(input):
    return hashlib.sha256(input.encode('utf-8')).hexdigest()