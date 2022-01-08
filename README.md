# Peristent storage with Rshiny on AWS managed Database
🍎
A demo **Rshiny** app demonstrating a _backend_  **MySQL** database hosted on **AWS**

The backend db was a my sql db provisioned on aws free tier - very temporary. 
- it means also because aws storage solutions dont have an R native sdk, so we can just use mysql drivers.
- It gets around the _statelessness_ that Rshiny apps are assumed to have, even in deployment.
🧏
## Below is an except of the tutorial 

### Start - form entry
Explore previous sessions data
Enter your own
<p align="center">
<img  height="400" src="storage_app/www/finish_edited.png">
</p>

### Push to database
Push to database once happy to save.
<p align="center">
<img height="400" src="storage_app/www/to_start_edited.png">
</p>


AG
<!--![](storage_app/www/finish_edited.png)
