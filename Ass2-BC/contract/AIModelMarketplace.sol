// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AIModelMarketplace {
    struct Model {   //Structure to store details of each AI model
        string name;
        string description;
        uint256 price;
        address payable creator;
        uint256 ratingSum; 
        uint256 ratingCount; 
    }
// Mapping to store all models with a unique ID
    mapping(uint256 => Model) public models;
    // Counter to keep track of how many models have been added
    uint256 public modelCount;
    // Address of the contract owner (who deployed the contract)
    address public owner;
// Constructor that sets the owner of the contract as the one who deploys it
    constructor() {
        owner = msg.sender;
    }
// Function to list a new AI model in the marketplace
    function listModel(string memory name, string memory description, uint256 price) public {
       // Add the new model to the mapping with a unique ID
        models[modelCount] = Model(name, description, price, payable(msg.sender), 0, 0);
        modelCount++;
    }
// Function to purchase a model
    function purchaseModel(uint256 modelId) public payable {
        // Ensure the model exists
        require(modelId < modelCount, "Model does not exist");
        // Fetch the model details
        Model storage model = models[modelId];
         // Ensure the correct price is paid
        require(msg.value == model.price, "Incorrect price");
        // Transfer the payment to the model creator
        model.creator.transfer(msg.value);
    }
// Function to rate a model between 1 and 5
    function rateModel(uint256 modelId, uint8 rating) public {
       // Ensure the model exists
        require(modelId < modelCount, "Model does not exist");
        // Fetch the model details
        Model storage model = models[modelId];
         // Ensure the rating is within the valid range
        require(rating >= 1 && rating <= 5, "Invalid rating");
        // Add the rating to the model's total rating sum and increment the rating count
        model.ratingSum += rating;
        model.ratingCount++;
    }
// Function for the contract owner to withdraw all funds from the contract
    function withdrawFunds() public {
         // Ensure only the owner can call this function
        require(msg.sender == owner, "Only the contract owner can withdraw funds");
       // Transfer the entire contract balance to the owner
        payable(owner).transfer(address(this).balance);
    }
 // Function to get the details of a specific model
    function getModelDetails(uint256 modelId) public view returns (string memory, string memory, uint256, address, uint256) {
        require(modelId < modelCount, "Model does not exist");
        // Fetch the model details
        Model memory model = models[modelId];
         // Calculate the average rating (if there are no ratings, return 0)
        uint256 averageRating = model.ratingCount == 0 ? 0 : model.ratingSum / model.ratingCount;
         // Return the model's name, description, price, creator, and average rating
        return (model.name, model.description, model.price, model.creator, averageRating);
    }
}
