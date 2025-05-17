// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract InventoryManagement {
    struct Product {
        string name;
        uint quantity;
        uint price;
        uint reorderThreshold;
    }

    mapping(uint => Product) public products;
    mapping(address => bool) public managers;

    address public owner = 0x0BFABb6471D6E953e06407078CC25E02699f543a;
    uint public productCounter = 0;

    event ProductAdded(uint productId, string name, uint quantity);
    event InventoryUpdated(uint productId, uint newQuantity);
    event ReorderTriggered(uint productId, uint reorderQuantity);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }

    modifier onlyManager() {
        require(managers[msg.sender] == true, "Only managers can perform this action");
        _;
    }

    constructor() {
        managers[owner] = true;
    }

    function addProduct(string memory _name, uint _quantity, uint _price, uint _reorderThreshold) public onlyManager {
        products[productCounter] = Product(_name, _quantity, _price, _reorderThreshold);
        emit ProductAdded(productCounter, _name, _quantity);
        productCounter++;
    }

    function updateInventory(uint _productId, uint _newQuantity) public onlyManager {
        products[_productId].quantity = _newQuantity;
        emit InventoryUpdated(_productId, _newQuantity);
        reorderIfNeeded(_productId);
    }

    function reorderIfNeeded(uint _productId) public onlyManager {
    if (products[_productId].quantity < products[_productId].reorderThreshold) {
        emit ReorderTriggered(_productId, products[_productId].quantity);
        }
    }   

    function addManager(address _manager) public onlyOwner {
        managers[_manager] = true;
    }

    function removeManager(address _manager) public onlyOwner {
        managers[_manager] = false;
    }

    // Hàm lấy chi tiết sản phẩm (không bắt buộc vì biến public đã auto tạo getter)
    function getProduct(uint _productId) public view returns (string memory, uint, uint, uint) {
        Product memory p = products[_productId];
        return (p.name, p.quantity, p.price, p.reorderThreshold);
    }
}
