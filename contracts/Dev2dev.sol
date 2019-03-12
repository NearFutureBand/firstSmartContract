pragma solidity >=0.4.25 <0.6.0;

contract Dev2dev {

    struct Order {
        uint id;
        uint balance; // how many tokens this order holds now ( balance = 2 * payment)
        uint payment; // how many tokens the worker will get for this order and should pay before the work
        address employer; // who created this order
        address worker; // who will accept to work on this order
        string about; // description of this order
        bool employerPaid; // did the employer stake his tokens to this order
        bool workerPaid; // did the worker stake his tokens to this order
        bool isComplete; // indicator that this order is complete
    }
    
    Order[] public orders;

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event NewOrderCreated(address _employer, uint _payment, string _about, uint indexed _id);
    event OrderAccepted(address _worker, uint indexed _id, address _employer);
    event OrderApproved(uint indexed _id);

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
            true,
            false,
            false
        );
        orders.push(order);
        emit NewOrderCreated(msg.sender, msg.value, _about, id);
    }

    /**
    * 
    */
    function getOrdersCount() external view returns(uint) {
        return orders.length;
    }

    /**
    *   returns indexes of uncomplete orders
    */
    /*function getUncompleteOrders() external view returns( uint[] memory ){
        uint[] memory result = new uint[](ownerZombieCount[_owner]);
        uint counter = 0;
        for (uint i = 0; i < zombies.length; i++) {
          if (zombieToOwner[i] == _owner) {
            result[counter] = i;
            counter++;
          }
        }
        return result;
    }*/


    function acceptOrder(uint _orderId) public payable {

        require(_orderId < orders.length, "There is no order with the given id");
        require(orders[_orderId].worker == address(0), "Somebody is already accepted this order");
        //add worker's payment
        require(msg.value >= orders[_orderId].payment, "Not enough money to accetp this order");
        orders[_orderId].balance += msg.value;
        
        //set worker address
        orders[_orderId].worker = msg.sender;
       
        //set boolean value to true
        orders[_orderId].workerPaid = true;

        emit OrderAccepted(msg.sender, _orderId, orders[_orderId].employer);
    }

    function approveOrder(uint _orderId) public {

        require(msg.sender == orders[_orderId].employer, "You cannot approve foreign order");
        require(orders[_orderId].employerPaid && orders[_orderId].workerPaid);
        
        sendMoneyToWorker( address(uint160(orders[_orderId].worker)), orders[_orderId].balance);
        
        orders[_orderId].balance = 0;
        
        orders[_orderId].isComplete = true;

        emit OrderApproved(_orderId);
    }

    function sendMoneyToWorker(address payable _worker, uint _amount) private {
        _worker.transfer(_amount);
    }
}
