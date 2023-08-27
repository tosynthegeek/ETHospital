// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

import "@openzeppelin/contracts/utils/Counters.sol";

contract Hospital {
    using Counters for Counters.Counter;

    Counters.Counter private _nurseCount; //total number of Nurses
    Counters.Counter private _patientCount; //total number of Patients
    // Counters.Counter private _inspectionCount; //total number of Inspection

    address public owner;
    // Cars public cars;

    // Struct to store patients information
    struct Patients {
        uint256 patientId;
        uint256 hospitalNo;
        address addr;
        string name;
        uint256 age;
        string history;
        string prescription;
        string date;
    }

    // Struct to store nurse information
    struct Nurse {
        uint256 itemId;
        address nurseAddress;
        string name;
        uint256 rank;
        string spzn;
        string date;
    }

    event PatientItem(uint256 patientId, uint256 hospitalNo, address addr, string name, uint256 age, string history, string prescription, string date);

    event NurseItem(uint256 itemId, address _address, string name, uint256 rank,string spzn, string date);

    // Mapping of nurse addresses to nurse IDs
    mapping(address => uint256) public nurse;
    // Mapping of patient addresses to patient IDs
    mapping(address => uint256) public patientz;
    // Mapping of patient IDs to patient details
    mapping(uint256 => Patients) public patients;
    // Mapping of nurse IDs to nurse details
    mapping(uint256 => Nurse) public nurz;

    constructor() {
        owner = msg.sender;
    }

    // Modifier to restrict access to only the contract owner
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    // Modifier to restrict access to only the owner or nurses
    modifier onlyAdmin() {
        if(msg.sender != owner) {
            if(nurse[msg.sender] == 0){
                revert("Error: invalid user");
            }     
        }
        _;
    }

    // Function to add a nurse to the system (only callable by the owner)
    function addNurse(address _addr, string memory _date, string memory _name, uint256 _rank, string memory _spzn) public onlyOwner {
        _nurseCount.increment(); //add 1 to the total number of items ever created
        uint256 itemId = _nurseCount.current();
        nurz[itemId] = Nurse(itemId, _addr, _name, _rank, _spzn, _date);
        // add the nurse to the mapping of
        nurse[_addr] = itemId;
        emit NurseItem(itemId, _addr, _name, _rank, _spzn, _date);
    }
    
    // Function to add a patient to the system (only callable by the owner or nurses)
    function addPatient(
        uint256 _hospitalNo,
        address _addr,
        string memory _name,
        uint256 _age,
        string memory _history,
        string memory _prescription,
        string memory _date
    ) public onlyAdmin {
        _patientCount.increment(); //add 1 to the total number of items ever created
        uint256 itemId = _patientCount.current();
        patientz[_addr] = itemId;
        patients[itemId] = Patients(itemId, _hospitalNo, _addr, _name, _age, _history, _prescription, _date);

        emit PatientItem(itemId, _hospitalNo, _addr, _name, _age, _history, _prescription, _date);
    }

    // Function to retrieve all patients' information
    function getAllPatients() public view returns (Patients[] memory) {
        uint256 count = _patientCount.current();
        uint256 index = 0;

        Patients[] memory items = new Patients[](count);

        for (uint256 i = 0; i < count; i++) {
            uint256 currentId = patients[i + 1].patientId;
            Patients storage currentItem = patients[currentId];
            items[index] = currentItem;
            index += 1;
        }
        return items;
    }

    // Function to retrieve patients' information by hospital number
    function getPatient(uint256 _hospitalNo) public view returns (Patients[] memory) {
        uint256 count = _patientCount.current();
        uint256 index = 0;

        Patients[] memory items = new Patients[](count);

        for (uint256 i = 0; i < count; i++) {
            if (patients[i + 1].hospitalNo == _hospitalNo) {
                uint256 currentId = patients[i + 1].patientId;
                Patients storage currentItem = patients[currentId];
                items[index] = currentItem;
                index += 1;
            }
        }
        return items;
    }

    // Function to retrieve all nurses' information
    function getAllNurse() public view returns (Nurse[] memory) {
        uint256 count = _nurseCount.current();
        uint256 index = 0;

        Nurse[] memory items = new Nurse[](count);

        for (uint256 i = 0; i < count; i++) {
            uint256 currentId = nurz[i + 1].itemId;
            Nurse storage currentItem = nurz[currentId];
            items[index] = currentItem;
            index += 1;
        }
        return items;
    }

    // Function to retrieve nurse information by nurse ID
    function getNurse(uint256 _nurseId) public view returns (Nurse[] memory) {
        uint256 count = _nurseCount.current();
        uint256 index = 0;

        Nurse[] memory items = new Nurse[](count);

        for (uint256 i = 0; i < count; i++) {
            if (nurz[i + 1].itemId == _nurseId) {
                uint256 currentId = nurz[i + 1].itemId;
                Nurse storage currentItem = nurz[currentId];
                items[index] = currentItem;
                index += 1;
            }
        }
        return items;
    }

    // Function to get the total count of nurses
    function getNurseCount() public view returns (uint256) {
        uint256 count = _nurseCount.current();
        return count;
    }
    
}