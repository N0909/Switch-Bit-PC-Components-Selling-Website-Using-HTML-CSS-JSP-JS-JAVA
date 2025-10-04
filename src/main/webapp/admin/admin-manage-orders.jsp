<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Manage Orders - SwitchBit</title>
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
            background: #2563eb;
            color: #fff;
        }
        .action-btn:hover {
            background: #1e40af;
        }
        .section-title {
            font-size: 20px;
            margin: 40px 0 16px 0;
            color: #23272b;
            font-weight: bold;
            text-align: left;
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
        .modal-form input, .modal-form select {
            padding: 9px;
            border-radius: 6px;
            border: 1px solid #d1d5db;
            font-size: 16px;
            width: 100%;
            box-sizing: border-box;
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
            .modal-form label, .modal-form input, .modal-form select {
                font-size: 15px;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>All Orders</h2>
        <table>
            <thead>
                <tr>
                    <th>#</th>
                    <th>Order ID</th>
                    <th>Customer</th>
                    <th>Date</th>
                    <th>Delivery Date</th>
                    <th>Status</th>
                    <th>Total</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <!-- Example order rows (replace with dynamic content as needed) -->
                <tr>
                    <td>1</td>
                    <td>ORD-1001</td>
                    <td>Jane Doe</td>
                    <td>2025-10-02</td>
                    <td>2025-10-04</td>
                    <td>Completed</td>
                    <td>$499.99</td>
                    <td>
                        <button class="action-btn" onclick="openModal('edit', 1)">Edit</button>
                    </td>
                </tr>
                <tr>
                    <td>2</td>
                    <td>ORD-1002</td>
                    <td>John Smith</td>
                    <td>2025-10-02</td>
                    <td>2025-10-05</td>
                    <td>Pending</td>
                    <td>$129.99</td>
                    <td>
                        <button class="action-btn" onclick="openModal('edit', 2)">Edit</button>
                    </td>
                </tr>
                <!-- More order rows here -->
            </tbody>
        </table>

        <div class="section-title">Pending Orders</div>
        <table>
            <thead>
                <tr>
                    <th>#</th>
                    <th>Order ID</th>
                    <th>Customer</th>
                    <th>Date</th>
                    <th>Delivery Date</th>
                    <th>Total</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <!-- Example pending order rows (replace with dynamic content as needed) -->
                <tr>
                    <td>1</td>
                    <td>ORD-1002</td>
                    <td>John Smith</td>
                    <td>2025-10-02</td>
                    <td>2025-10-05</td>
                    <td>$129.99</td>
                    <td>
                        <button class="action-btn" onclick="openModal('edit', 2)">Edit</button>
                    </td>
                </tr>
                <tr>
                    <td>2</td>
                    <td>ORD-1003</td>
                    <td>Sarah Lee</td>
                    <td>2025-10-01</td>
                    <td>2025-10-07</td>
                    <td>$249.00</td>
                    <td>
                        <button class="action-btn" onclick="openModal('edit', 3)">Edit</button>
                    </td>
                </tr>
                <!-- More pending orders here -->
            </tbody>
        </table>
    </div>

    <!-- Popup Modal -->
    <div id="modal" class="modal">
        <div class="modal-content">
            <span class="close" onclick="closeModal()">&times;</span>
            <h3 id="modal-title" style="margin-bottom:22px;">Edit Order</h3>
            <form class="modal-form" id="orderForm">
                <label for="delivery_date">Delivery Date</label>
                <input type="date" id="delivery_date" name="delivery_date">

                <label for="status">Order Status</label>
                <select id="status" name="status">
                    <option value="Pending">Pending</option>
                    <option value="Processing">Processing</option>
                    <option value="Completed">Completed</option>
                    <option value="Canceled">Canceled</option>
                </select>

                <button type="submit" class="submit-btn" id="modal-submit">Update Order</button>
            </form>
        </div>
    </div>
    <script>
        // Modal controls
        function openModal(type, orderId) {
            document.getElementById('modal').style.display = "block";
            document.getElementById('orderForm').reset();
            document.getElementById('modal-title').textContent = "Edit Order";
            document.getElementById('modal-submit').textContent = "Update Order";
            // Demo: Fill with example data for editing (replace with real data in integration)
            if(orderId === 1) {
                document.getElementById('delivery_date').value = "2025-10-04";
                document.getElementById('status').value = "Completed";
            } else if(orderId === 2) {
                document.getElementById('delivery_date').value = "2025-10-05";
                document.getElementById('status').value = "Pending";
            } else if(orderId === 3) {
                document.getElementById('delivery_date').value = "2025-10-07";
                document.getElementById('status').value = "Pending";
            }
        }
        function closeModal() {
            document.getElementById('modal').style.display = "none";
        }
        // Close modal when clicking outside
        window.onclick = function(event) {
            const modal = document.getElementById('modal');
            if (event.target == modal) closeModal();
        }
        // Demo form submit
        document.getElementById('orderForm').onsubmit = function(e) {
            e.preventDefault();
            // Collect and process form data here
            alert('Order updated (demo; integrate backend as needed)');
            closeModal();
        }
    </script>
</body>
</html>