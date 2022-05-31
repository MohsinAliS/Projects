// SPDX-License-Identifier: MIT
pragma solidity >0.5.0;
// a project on sale & purchase of property 
contract landregmarket
{

uint private landId;
//land registration
    struct landregistry
	{   
        uint _landid;
        uint _propertyid;
		string area;
		string city;
        string state;
		uint landprice;
        address payable landowner;
	}

// buyer details     
    struct buyer 
    {
        string  name; 
        uint age; 
        string city;
        uint cnic; 
        string email;
    }

// seller details
    struct seller
    {
        string  name; 
        uint age; 
        string city;
        uint cnic; 
        string email;
    }

//land inspector
    struct landinspector
    {
        string Name; 
        uint Age; 
        string Designation;
    }

//Constructor and Modifier     
    address private owner;
	
    modifier onlyme()
	{
		require(msg.sender == owner, "you are not inspector" );
		_;
	}

    modifier onlyseller()
    {
        require(
            msg.sender==landregistration[landId].landowner,"you are not owner of this land"
        );_;
    }
	constructor()
	{
		owner=msg.sender;
	}
    
//land registry    
    mapping (uint => landregistry) public landregistration;
    mapping (uint => bool) public isvalidland;

    function verifyland (uint _landid) public onlyme {
        isvalidland[_landid]=true;}
	
    function landregistra
    (
        uint _landid,
        uint _propertyid,
        string memory _area,
        string memory _city,
        string memory _state,
        uint landprice
     ) public 
	{   
    
    require(isvalidseller[msg.sender] == true,"first veryfy your self ");
        landId ++;
        landregistration[landId]= landregistry(
        _landid,
        _propertyid,
        _area,
        _city,
        _state,
        landprice, 
        payable (msg.sender));
    }

    function getlandowner(uint _landid) public view returns(uint,address)
    {
    return(landregistration[_landid]._landid, landregistration[_landid].landowner);
    }


    mapping (address => buyer) public buyerdata;
    mapping (address => bool) public isvalidbuyer;
    function verifybuyer (address _addr) public onlyme 
    {
        isvalidbuyer[_addr]=true;
    }

    function buyerdetails
    (
        string memory _name,
        uint _age, 
        string memory _city, 
        uint _cnic, 
        string memory _email
    ) public 
    {
        buyerdata[msg.sender] = buyer (_name, _age, _city, _cnic, _email);
    }

    mapping (address => seller) public sellerdata;
    mapping (address => bool) public isvalidseller;
    function verifyseller(address _addr) public onlyme{
        isvalidseller[_addr]=true;
    }
    function sellerdetails
    (
        string memory _name, 
        uint _age, 
        string memory _city, 
        uint _cnic, 
        string memory _email
    ) public
    {
    sellerdata[msg.sender] = seller (_name, _age, _city, _cnic, _email);
    }
    
    mapping (address => landinspector) public inspectordata;
    function inspectordetails
    ( 
        string memory _Name, 
        uint _Age, 
        string memory _Designation
    ) public onlyme
    {
    inspectordata[owner] = landinspector( _Name, _Age, _Designation);
    }

    function purchasetheland
    (
        uint _landid
    ) public payable returns ( string memory)
    {
    require(isvalidland[_landid] == true,"first veryfy your land ");
    require(msg.sender != owner,"you are the owner");
    require(isvalidbuyer[msg.sender] == true,"first veryfy your self ");
    require(msg.value == landregistration[_landid].landprice ,"you enter wrong amount");
        landregistration[_landid].landowner.transfer(msg.value);
        if(landregistration[_landid].landowner!=msg.sender)
    {
        landregistration[_landid].landowner=payable(msg.sender);     
    }

       else
    {
          return "you are the owner the land";
    }
        
        return "congrates you purchase the land";
   
    }

   function changeOwner
   (
       uint landid, 
       address payable _newOwner
    ) onlyseller public 
    {
        landregistration[landid].landowner= _newOwner;
    }
}






 
