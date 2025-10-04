<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Manage Products - SwitchBit</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            background: #f4f6f8;
        }
        .container {
            max-width: 1100px;
            margin: 60px auto 0 auto;
            background: #fff;
            border-radius: 15px;
            box-shadow: 0 2px 16px rgba(0,0,0,0.07);
            padding: 40px 30px;
        }
        h2 {
            color: #23272b;
            margin-bottom: 30px;
            text-align: center;
        }
        .add-btn {
            background: #2563eb;
            color: #fff;
            border: none;
            border-radius: 8px;
            padding: 14px 28px;
            font-size: 18px;
            font-weight: 500;
            cursor: pointer;
            transition: background 0.2s;
            box-shadow: 0 1px 4px rgba(0,0,0,0.08);
            letter-spacing: 0.5px;
            margin-bottom: 20px;
            display: block;
            margin-left: auto;
        }
        .add-btn:hover {
            background: #1e40af;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
            font-size: 17px;
        }
        th, td {
            padding: 14px 12px;
            text-align: left;
        }
        th {
            background: #f5f5f5;
            color: #374151;
        }
        tr:nth-child(even) {
            background: #f9f9f9;
        }
        .action-btn {
            border: none;
            border-radius: 6px;
            padding: 9px 18px;
            cursor: pointer;
            font-size: 15px;
            font-weight: 500;
            margin-right: 8px;
            box-shadow: 0 1px 4px rgba(0,0,0,0.08);
            transition: background 0.2s;
        }
        .edit-btn {
            background: #2563eb;
            color: #fff;
        }
        .edit-btn:hover {
            background: #1e40af;
        }
        .delete-btn {
            background: #e11d48;
            color: #fff;
        }
        .delete-btn:hover {
            background: #be123c;
        }
        /* Popup modal styles */
        .modal {
            display: none; 
            position: fixed; 
            z-index: 999; 
            left: 0; top: 0; width: 100%; height: 100%; 
            overflow: auto; 
            background-color: rgba(0,0,0,0.35); 
        }
        .modal-content {
            background-color: #fff;
            margin: 90px auto;
            padding: 35px 30px 30px 30px;
            border-radius: 12px;
            width: 100%;
            max-width: 470px;
            box-shadow: 0 6px 18px rgba(0,0,0,0.16);
            position: relative;
        }
        .close {
            color: #aaa;
            position: absolute;
            right: 18px;
            top: 18px;
            font-size: 28px;
            font-weight: bold;
            cursor: pointer;
        }
        .close:hover { color: #e11d48; }
        .modal-form {
            display: flex;
            flex-direction: column;
            gap: 16px;
        }
        .modal-form label {
            font-size: 16px;
            margin-bottom: 4px;
            color: #23272b;
        }
        .modal-form input, .modal-form textarea, .modal-form select {
            padding: 9px;
            border-radius: 6px;
            border: 1px solid #d1d5db;
            font-size: 16px;
            width: 100%;
            box-sizing: border-box;
        }
        .modal-form textarea {
            min-height: 60px;
            resize: vertical;
        }
        .modal-form input[type="file"] {
            padding: 4px;
        }
        .modal-form .img-preview {
            margin-top: 6px;
            width: 80px;
            height: 80px;
            object-fit: cover;
            border-radius: 7px;
            border: 1px solid #cbd5e1;
            display: none;
        }
        .modal-form .submit-btn {
            background: #2563eb;
            color: #fff;
            border: none;
            border-radius: 8px;
            padding: 12px 0;
            font-size: 18px;
            font-weight: 500;
            cursor: pointer;
            transition: background 0.2s;
            margin-top: 8px;
        }
        .modal-form .submit-btn:hover {
            background: #1e40af;
        }
        @media (max-width: 900px) {
            .container { max-width: 98%; padding: 15px 4px; }
            table { font-size: 15px; }
            th, td { padding: 7px 5px; }
            .action-btn { font-size: 13px; padding: 7px 12px; }
            .modal-content { max-width: 99%; padding: 12px 8px 18px 8px;}
            .modal-form label, .modal-form input, .modal-form textarea, .modal-form select {
                font-size: 15px;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>All Products</h2>
        <button class="add-btn" onclick="openModal('add')">Add Product</button>
        <table>
            <thead>
                <tr>
                    <th>#</th>
                    <th>Product Name</th>
                    <th>Category</th>
                    <th>Price</th>
                    <th>Stock</th>
                    <th>Image</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <!-- Example product rows (replace with dynamic content as needed) -->
                <tr>
                    <td>1</td>
                    <td>Intel Core i7 12700K</td>
                    <td>Processor</td>
                    <td>$319.99</td>
                    <td>8</td>
                    <td>
                        <img src="https://via.placeholder.com/60x60?text=CPU" style="border-radius:6px;">
                    </td>
                    <td>
                        <button class="action-btn edit-btn" onclick="openModal('edit', 1)">Edit</button>
                        <button class="action-btn delete-btn">Delete</button>
                    </td>
                </tr>
                <tr>
                    <td>2</td>
                    <td>Kingston Fury 16GB DDR5</td>
                    <td>RAM</td>
                    <td>$89.99</td>
                    <td>3</td>
                    <td>
                        <img src="https://via.placeholder.com/60x60?text=RAM" style="border-radius:6px;">
                    </td>
                    <td>
                        <button class="action-btn edit-btn" onclick="openModal('edit', 2)">Edit</button>
                        <button class="action-btn delete-btn">Delete</button>
                    </td>
                </tr>
                <!-- More product rows here -->
            </tbody>
        </table>
    </div>

    <!-- Popup Modal -->
    <div id="modal" class="modal">
        <div class="modal-content">
            <span class="close" onclick="closeModal()">&times;</span>
            <h3 id="modal-title" style="margin-bottom:22px;">Add / Edit Product</h3>
            <form class="modal-form" id="productForm">
                <label for="product_name">Product Name *</label>
                <input type="text" id="product_name" name="product_name" maxlength="150" required>

                <label for="description">Description</label>
                <textarea id="description" name="description"></textarea>

                <label for="price">Price *</label>
                <input type="number" id="price" name="price" min="0" step="0.01" required>

                <label for="stock_quantity">Stock Quantity *</label>
                <input type="number" id="stock_quantity" name="stock_quantity" min="0" required>

                <label for="category_id">Category</label>
                <select id="category_id" name="category_id">
                    <option value="">Select Category</option>
                    <option value="processor">Processor</option>
                    <option value="ram">RAM</option>
                    <option value="motherboard">Motherboard</option>
                    <!-- Add more categories as needed -->
                </select>

                <label for="product_img">Product Image</label>
                <input type="file" id="product_img" name="product_img" accept="image/*" onchange="previewImage(event)">
                <img id="imgPreview" class="img-preview" src="#" alt="Image Preview">

                <button type="submit" class="submit-btn" id="modal-submit">Save Product</button>
            </form>
        </div>
    </div>
    <script>
        // Modal controls
        function openModal(type, productId) {
            document.getElementById('modal').style.display = "block";
            document.getElementById('productForm').reset();
            document.getElementById('imgPreview').style.display = 'none';
            if(type === 'add') {
                document.getElementById('modal-title').textContent = "Add Product";
                document.getElementById('modal-submit').textContent = "Add Product";
            } else {
                document.getElementById('modal-title').textContent = "Edit Product";
                document.getElementById('modal-submit').textContent = "Update Product";
                // Demo: Fill with example data for editing (replace with real data in integration)
                if(productId === 1) {
                    document.getElementById('product_name').value = "Intel Core i7 12700K";
                    document.getElementById('description').value = "High performance CPU for gaming and productivity.";
                    document.getElementById('price').value = "319.99";
                    document.getElementById('stock_quantity').value = "8";
                    document.getElementById('category_id').value = "processor";
                    document.getElementById('imgPreview').src = "https://via.placeholder.com/80x80?text=CPU";
                    document.getElementById('imgPreview').style.display = 'block';
                } else if(productId === 2) {
                    document.getElementById('product_name').value = "Kingston Fury 16GB DDR5";
                    document.getElementById('description').value = "Fast DDR5 RAM for next-gen PCs.";
                    document.getElementById('price').value = "89.99";
                    document.getElementById('stock_quantity').value = "3";
                    document.getElementById('category_id').value = "ram";
                    document.getElementById('imgPreview').src = "https://via.placeholder.com/80x80?text=RAM";
                    document.getElementById('imgPreview').style.display = 'block';
                }
            }
        }
        function closeModal() {
            document.getElementById('modal').style.display = "none";
        }
        // Image preview
        function previewImage(event) {
            const input = event.target;
            const preview = document.getElementById('imgPreview');
            if (input.files && input.files[0]) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    preview.src = e.target.result;
                    preview.style.display = 'block';
                }
                reader.readAsDataURL(input.files[0]);
            } else {
                preview.src = "#";
                preview.style.display = 'none';
            }
        }
        // Close modal when clicking outside
        window.onclick = function(event) {
            const modal = document.getElementById('modal');
            if (event.target == modal) closeModal();
        }
        // Demo form submit
        document.getElementById('productForm').onsubmit = function(e) {
            e.preventDefault();
            // Collect and process form data here
            alert('Product saved (demo; integrate backend as needed)');
            closeModal();
        }
    </script>
</body>
</html>