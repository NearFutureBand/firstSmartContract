pragma solidity >=0.4.25 <0.6.0;

contract MetaCoin {

    struct Order {
        uint id;
        uint balance; // how many tokens this order holds now ( balance = 2 * payment)
        uint payment; // how many tokens the worker will get for this order and should pay before the work
        address employer; // who created this order
        address worker; // who will accept to work on this order
        string about; // description of this order
        bool workerPaid; // did the worker stake his tokens to this order
        bool employerPaid; // did the employer stake his tokens to this order
        bool isComplete; // indicator that this order is complete
    }
    
    Order[] public orders;

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event NewOrderCreated(address _creator, uint _payment, string _about);
    event OrderAccepted();

    constructor() public {
        
    }

    /**
    * creates a new order with worker address = 0
     */
    function createOrder(string memory _about) public payable {
        // the id of an order creating
        uint id = orders.length;

        Order memory order = Order(
            id,
            msg.value,
            msg.value,
            msg.sender,
            address(0),
            _about,
            false,
            true
        );
        orders.push(order);
        emit NewOrderCreated(msg.sender, msg.value, _about);
    }

    /**
    * for frontend to show all existing orders
     */
    function listOrders() external view {

    }

    /*function sendCoin(address receiver, uint amount) public returns(bool sufficient) {
        if (balances[msg.sender] < amount) return false;
        balances[msg.sender] -= amount;
        balances[receiver] += amount;
        emit Transfer(msg.sender, receiver, amount);
        return true;
    }

    function getBalanceInEth(address addr) public view returns(uint){
      return ConvertLib.convert(getBalance(addr),2);
    }

    function getBalance(address addr) public view returns(uint) {
      return balances[addr];
    }*/
}
