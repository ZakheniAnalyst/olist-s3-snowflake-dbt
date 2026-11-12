import getpass
from cryptography.hazmat.primitives.asymmetric import rsa
from cryptography.hazmat.primitives import serialization

passphrase = getpass.getpass("Choose a passphrase: ").encode()
key = rsa.generate_private_key(public_exponent=65537, key_size=2048)

with open("powerbi_key.p8", "wb") as f:
    f.write(key.private_bytes(
        serialization.Encoding.PEM,
        serialization.PrivateFormat.PKCS8,
        serialization.BestAvailableEncryption(passphrase)))

with open("powerbi_key.pub", "wb") as f:
    f.write(key.public_key().public_bytes(
        serialization.Encoding.PEM,
        serialization.PublicFormat.SubjectPublicKeyInfo))