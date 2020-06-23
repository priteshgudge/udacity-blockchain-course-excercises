pragma solidity ^0.4.24;

//Defin a contract lemonade stand

contract LemonadeStand{
    
    //Variable ownner
    address owner;
    
    //Variable SKU Count
    uint256 skuCount;
    
    //Enum State with value (For Sale & Sold)
    enum State { ForSale, Sold, Shipped }
    
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
    event Shipped(uint256 sku);
    
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
    
        //modifier check Shipped State
    modifier shipped(uint256 _sku){
        require(items[_sku].state == State.Shipped);
        _ ;
    }
    
    // Check and Refund Value greater than price
    modifier checkValue(uint _sku) {
        _;
        uint128 _price = items[_sku].price;
        uint128 amountToRefund = uint128(msg.value) - _price;
        items[_sku].buyer.transfer(amountToRefund);
}

    
    // Constructor of contract
    constructor() public{
        owner = msg.sender;
        skuCount = 0;
    }
    
    //Add Item function
    function addItem(string _name, uint128 _price)onlyOwner public{
        skuCount = skuCount + 1;
        
        emit ForSale(skuCount);
        
        //Add New Item to inventory and mark it for Sale
        items[skuCount] = Item({name: _name, sku: skuCount,  price: _price, state: State.ForSale, seller: msg.sender, buyer: 0});
    }
    
    // Buy Item
    function buyItem(uint256 _itemSKU) forSale(_itemSKU)  paidEnough(items[_itemSKU].price) checkValue(_itemSKU) public payable {
       
       uint128 price = items[_itemSKU].price;
       
       items[_itemSKU].state = State.Sold;
       items[_itemSKU].buyer = msg.sender;
       
       items[_itemSKU].seller.transfer(price);
       
       
       emit Sold(_itemSKU);
        
    }
    
    // Fetch items
    
    function fetchItem(uint256 _itemSKU)shipped(_itemSKU) verifyCaller(items[_itemSKU].buyer) public view returns 
    (string name, uint256 sku, uint128 price, string stateStr, address seller, address buyer){
        Item memory item = items[_itemSKU];
        
        State state;
        name = item.name;
        sku = item.sku;
        price = item.price;
        state = item.state;
        seller = item.seller;
        buyer = item.buyer;
        
        if (state == State.ForSale){
            stateStr = "For Sale";
        }else{
            stateStr = "Sold";
        }
        
    }
    
    //Ship Item After Sale
    function shipItem(uint256 _itemSKU) verifyCaller(items[_itemSKU].seller) sold(_itemSKU) public{
        
        items[_itemSKU].state = State.Shipped;
        
        emit Shipped(_itemSKU);
        
    }
}
