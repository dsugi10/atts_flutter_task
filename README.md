# atts_flutter_task
Task Submission for ATTS Technologies

Credentials:
    - Email: admin@gmail.com
    - Password: Admin@123

Requirements

1. Product Management (CRUD - Jewellery Products)
     Add, update, delete, and list products.
     UI with text/number inputs, category selection, discount & tax options.
     Image selection UI (Optional image upload; if no backend, skip upload integration).
2. Billing System
     Select products, enter quantity, apply discounts & taxes.
     Real-time total calculations.
     PDF invoice generation with product details, total, discount, and taxes.
3. Billing History
     Store and display previous billing records with search, filter & sorting.
     Pagination and lazy loading for performance.
4. UI & Micro Widgets
     Material Design for a modern, responsive UI.
     Reusable UI components (buttons, product lists, billing summary, etc.)
5. Authentication (Optional)
     Login page using GetX, Provider, or Bloc.
6. Backend (Optional)
     If required, use Node.js & MongoDB, else use local storage.


Features Implemented

1. Product Management (CRUD - Jewellery Products)
    - Product data is stored locally in-memory using a list maintained in the controller.
    - This allows full CRUD operations (Create, Read, Update, Delete) within the app session.
    - Since there is no backend the data will reset on hot restart or app relaunch.
    - Image Selection is done using Cloudinary for uploading and displaying images 

2. Billing System
    - Allows user to select products from the list of products created and enter quantity 
    - Real time calculation is done on taxes and discount
    - PDF is generated

3. Billing History
    - On invoice bill confirmation the bill details are stored and displyed in the bill history page
    - Can be sorted ascending/descending based on total bill amount
    - Filtered based on bill date 
    - Can be serached using customer name 

4. UI & Micro Widgets
    - Used Material design and reusable UI components

5. Authentication
    - Login page is present where email and password is required 
    - State is maintained using GetX 

