# egrove_task

### USER STORY


For login we have collected the email and password from the user and called the Bloc event LoginUserEvent and from there we are calling the API and if the statusCode is 200 we are adding the token to shared preferences using AppUtils and then we are checking weather the token is empty or not and proceeding to dashboard.


In dashboard we are calling the GetCustomerDetailsEvent where the customer details are fetched currently the API is not working but have implemented everything 

Similarly in the SIgnup API we have called the SignupUserEvent where we pass all the required data and we call the API. That API is also not working and have implemented all the fields and validations.


## Installation

### System Requirements
- Flutter ( 3.16.9 ) 

1. Clone the repository:

    ```bash
    git clone https://github.com/senkeshkhan/egrove_task.git
    ```

2. Navigate to the project directory:

    ```bash
    cd egrove_task
    ```

3. Install dependencies:

    ```bash
    flutter pub get
    ```

4. Run the application:

    ```bash
    flutter run
    ```

