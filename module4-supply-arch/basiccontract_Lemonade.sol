pragma solidity ^0.4.24;

//Defin a contract lemonade stand

contract LemonadeStand{
    
    //Variable ownner
    address owner;
    
    //Variable SKU Count
    uint256 skuCount;
    
    //Enum State with value (For Sale & Sold)
    enum State { ForSale, Sold }
    
    //Struct Item
    struct Item{
        string name;
        uint256 sku;
        uint128 price;
        State state;
        address seller;
        address buyer;
        
    }
    
    // Define Mapping SKU to Item
    mapping (uint256 => Item) items;
    
    //Events
    event ForSale(uint256 skuCount);
    event Sold(uint256 sku);
    
    // Deine an only owner verificyaction
    
    modifier onlyOwner(){
        require(msg.sender == owner);
        _ ; 
    }
    
    // Define a modifier that verifies the caller
    modifier verifyCaller(address _address){
        require(msg.sender == _address);
        _ ;
    }
    
    // Define a modifier that verifies paid amount is sufficne to cover pricew
    modifier paidEnough(uint128 price){
        require(msg.value >= price);
        _ ;
    }
    
    // Define a modifier which checks if an item is for Sale
    modifier forSale(uint256 _sku){
        require(items[_sku].state == State.ForSale);
        _ ;
    }
    
    //modifier check sold State
    modifier sold(uint256 _sku){
        require(items[_sku].state == State.Sold);
        _ ;
    }
    
    // Constructor of contract
    constructor() public{
        owner = msg.sender;
        skuCount = 0;
    }
    
    //Add Item function
    function addItem(string _name, uint128 _price){
        skuCount = skuCount + 1;
        
        emit ForSale(skuCount);
        
        //Add New Item to inventory and mark it for Sale
        items[skuCount] = Item{name: _name, price: _price, state: State.ForSale, seller: msg.sender, buyer: 0};
    }
    
    // Buy Item
}
