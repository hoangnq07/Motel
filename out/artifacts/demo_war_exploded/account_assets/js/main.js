// Thêm các hàm xử lý sự kiện tương ứng cho Người dùng
function showBookForm() {
    document.getElementById("bookForm").style.display = "block";
    document.getElementById("action").value = "add";
}

function cancelBookForm() {
    document.getElementById("bookForm").style.display = "none";
}

function saveBook() {
    // Xử lý lưu thông tin Người dùng
    cancelBookForm();
}
function editBook(bookId) {
    document.getElementById("authorName").value = document.getElementById("authorName_" + bookId).value;
    document.getElementById("birthday").value = document.getElementById("authorBirthday_"+ bookId).value;
    document.getElementById("bio").innerHTML = document.getElementById("authorBio_"+ bookId).value;
    
    document.getElementById("publisherName").value = document.getElementById("publisherName_"+ bookId).value;
    document.getElementById("establishedDate").value = document.getElementById("establishedDate_"+ bookId).value;
    
    document.getElementById("id").value = document.getElementById("bookId_"+ bookId).value;
    document.getElementById("genre").value = document.getElementById("genre_"+ bookId).value;
    document.getElementById("description").innerHTML = document.getElementById("description_"+ bookId).value;
    document.getElementById("quantity").value = document.getElementById("quantity_"+ bookId).value;
    document.getElementById("price").value = document.getElementById("price_"+ bookId).value;
    document.getElementById("image").innerHTML = document.getElementById("image_"+ bookId).value;

    // Display the bookForm
    document.getElementById("bookForm").style.display = "block";
    document.getElementById("action").value = "update";
}





function deleteBook() {
    // Xử lý xóa Người dùng
    document.getElementById("action").value = "delete";
}

// Thêm các hàm xử lý sự kiện tương ứng cho Người dùng
function showUserForm() {
    document.getElementById("userForm").style.display = "block";
}

function cancelUserForm() {
    document.getElementById("userForm").style.display = "none";
}

function saveUser() {
    // Xử lý lưu thông tin Người dùng
    cancelUserForm();
}

function editUser(userId) {
    var row = document.querySelector(`[data-user-id="${userId}"]`);
    document.getElementById("action").value = "update";
    
    var id = row.dataset.UserId;
    var username = row.dataset.userUsername;
    var password = row.dataset.userPassword;
    var name = row.dataset.userName;
    var email = row.dataset.userEmail;
    var phone = row.dataset.userPhone;
    var address = row.dataset.userAddress;
    var role = row.dataset.userRole;
    var isActive = row.dataset.userIsActive;    
    // ... repeat for other data attributes

    document.getElementById("userId").value = id ;
    document.getElementById("username").value = username;
    document.getElementById("password").value = password;
    document.getElementById("name").value = name;
    document.getElementById("email").value = email;
    document.getElementById("phone").value = phone;
    document.getElementById("address").value = address;
    document.getElementById("role").value = role;
    document.getElementById("isActive").value = isActive;
    
    console.log(username, password, name, email, phone, address, role, isActive);
    showUserForm();
}


function deleteUser(userId) {
    // Xử lý xóa Người dùng
    // Gọi API hoặc xử lý dữ liệu theo nhu cầu của bạn
}