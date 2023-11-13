var c = db.companies.find({founded_year:1905},{_id:1, name:1, category_code:1})
while(c.hasNext()) printjson(c.next())



db.companies.find({name:"Facebook"},{number_of_employees:1, founded_year:1,_id:0})
