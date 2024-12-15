
from web3 import HTTPProvider, Web3, AsyncWeb3
import asyncio
import time

w3 = Web3(Web3.HTTPProvider('http://127.0.0.1:8545'))

if not w3.is_connected():
    raise Exception("Unable to connect to the blockchain")

def call_python_function(data):
    print(f"Function called from blockchain on server with data: {data}")
    # Your logic here

contract_address= "0x5FbDB2315678afecb367f032d93F642f64180aa3"
contract_abi = [{"type":"constructor","inputs":[],"stateMutability":"nonpayable"},{"type":"function","name":"registerSubNetOwner","inputs":[],"outputs":[],"stateMutability":"payable"},{"type":"function","name":"setStackingAmount","inputs":[{"name":"value","type":"uint256","internalType":"uint256"}],"outputs":[],"stateMutability":"nonpayable"},{"type":"event","name":"subNetRegisterd","inputs":[{"name":"subnetOwner","type":"address","indexed":False,"internalType":"address"},{"name":"subnetID","type":"uint256","indexed":False,"internalType":"uint256"}],"anonymous":False}]

contract = w3.eth.contract(address=contract_address, abi=contract_abi)

def main():
    event_filter = contract.events.subNetRegisterd.create_filter(from_block='latest')
    print("registered event filter")
    while True:
        for event in event_filter.get_new_entries():
            print(event.args)
            call_python_function(event.args.subnetID)
            call_python_function(event.args.subnetOwner)
        time.sleep(10)

if __name__ == '__main__':
    main()