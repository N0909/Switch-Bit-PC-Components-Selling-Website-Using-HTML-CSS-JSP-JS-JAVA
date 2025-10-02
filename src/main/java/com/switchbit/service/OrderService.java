package com.switchbit.service;

import com.switchbit.model.*;
import com.switchbit.util.*;
import com.switchbit.dao.*;
import com.switchbit.dto.*;
import com.switchbit.exceptions.*;

import java.util.List;
import java.util.ArrayList;
import java.sql.*;

public class OrderService {
    private OrderDAO order_dao;
    private CartDAO cart_dao;

    public OrderService() {
        this.order_dao = new OrderDAO();
        this.cart_dao = new CartDAO();
    }

    public Order getOrder(String order_id) throws DataAccessException {
        Order order = null;
        try (Connection conn = DBConnection.getConnection()) {
            order = order_dao.getOrder(conn, order_id);
        } catch (SQLException e) {
            throw new DataAccessException("failed to get order" + e.getMessage());
        }
        return order;
    }

    public List<Order> getOrders(User user) throws DataAccessException {
        List<Order> orders = new ArrayList<Order>();
        try (Connection conn = DBConnection.getConnection()) {
            orders = order_dao.getOrders(conn, user);
        } catch (SQLException e) {
            throw new DataAccessException("failed to fetch orders");
        }
        return orders;
    }

    public List<OrderItemDTO> getOrderItems(Order order) throws DataAccessException {
        List<OrderItemDTO> orderitems = new ArrayList<OrderItemDTO>();
        try (Connection conn = DBConnection.getConnection()) {
            orderitems = order_dao.getOrderItems(conn, order);
        } catch (SQLException e) {
            throw new DataAccessException("failed to get items for order id:" + order.getOrder_id());
        }
        return orderitems;
    }

    /**
     * Places an order based on the items in the user's cart.
     */
    public String placeCartOrder(CartDTO dto)
            throws RollBackException, DataAccessException, CloseConnectionException {
        Connection conn = null;

        try {
        	
            Order order = new Order();
            List<OrderItem> orderItems = new ArrayList<>();

            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            int current_order_val = IdGeneratorDAO.getCurrentIdVal(conn, "orders");
            String order_id = MiscUtil.idGenerator("OD000", current_order_val);

            order.setOrder_id(order_id);
            order.setUser_id(dto.getCart().getUser_id());
            order.setOrder_date(new Timestamp(System.currentTimeMillis()));
            order.setTotal_amount(MiscUtil.CalcuateTotal(dto));
            order.setOrder_status("PENDING"); 

            for (CartItemDTO item : dto.getItems()) {
                int current_val = IdGeneratorDAO.getCurrentIdVal(conn, "order_item");
                String order_item_id = MiscUtil.idGenerator("OI0000", current_val);

                orderItems.add(new OrderItem(
                        order_item_id,
                        order.getOrder_id(),
                        item.getProduct().getProduct_id(),
                        item.getCartItem().getQuantity()
                ));

                IdGeneratorDAO.setNextIdVal(conn, "order_item", current_val);
            }

            IdGeneratorDAO.setNextIdVal(conn, "orders", current_order_val);

            order_dao.placeCartOrder(conn, order, orderItems);

            cart_dao.deleteAllCartItems(conn, dto.getCart());

            conn.commit();
            
            return order.getOrder_id();

        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException e1) {
                    throw new RollBackException("Failed to rollback transaction");
                }
            }
            throw new DataAccessException("Failed to place order", e);

        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    throw new CloseConnectionException("Failed to close connection");
                }
            }
        }
    }

    /**
     * Places an order for a single product ("Buy Now").
     */
    public String placeOrder(User user, Product product, int quantity)
            throws RollBackException, DataAccessException, CloseConnectionException {
        Connection conn = null;

        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            Order order = new Order();
            order.setUser_id(user.getUserId());
            order.setOrder_date(new Timestamp(System.currentTimeMillis()));
            order.setTotal_amount(product.getPrice() * quantity);
            order.setOrder_status("PENDING"); 

            int current_order_val = IdGeneratorDAO.getCurrentIdVal(conn, "orders");
            String order_id = MiscUtil.idGenerator("OD000", current_order_val);
            order.setOrder_id(order_id);

            OrderItem order_item = new OrderItem();
            order_item.setOrder_id(order.getOrder_id());
            order_item.setProduct_id(product.getProduct_id());
            order_item.setQuantity(quantity);

            int current_val = IdGeneratorDAO.getCurrentIdVal(conn, "order_item");
            String order_item_id = MiscUtil.idGenerator("OI0000", current_val);
            order_item.setOrder_item_id(order_item_id);

            order_dao.placeOrder(conn, order, order_item);

            IdGeneratorDAO.setNextIdVal(conn, "orders", current_order_val);
            IdGeneratorDAO.setNextIdVal(conn, "order_item", current_val);

            conn.commit();
            
            return order.getOrder_id();

        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException e1) {
                    throw new RollBackException("Failed to rollback transaction");
                }
            }
            throw new DataAccessException("Failed to place order" + e);

        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    throw new CloseConnectionException("Failed to close connection");
                }
            }
        }
    }
    
    public void updateOrderStatus(String order_id, String status) throws RollBackException, DataAccessException, CloseConnectionException  {
    	Connection conn = null;
    	try {
    		conn = DBConnection.getConnection();
    		conn.setAutoCommit(false);
    		order_dao.updateOrderStatus(conn, order_id, status);
    		conn.commit();
    	}catch(SQLException e) {
    		if (conn!=null) {
    			try {
					conn.rollback();
				} catch (Exception e2) {
					throw new RollBackException("Failed to Rollback Transaction", e);
				}
    		}
    		throw new DataAccessException("failed to update Status Cause: "+e.getMessage());
    	}finally {
    		if (conn!=null) {
    			try {
					conn.close();
				} catch (SQLException e) {
					throw new CloseConnectionException("failed to close connection", e);
				}
    		}
    	}
    }
    
    public void updateDeliveryDate(String order_id, Date date) throws RollBackException, DataAccessException, CloseConnectionException {
    	Connection conn = null;
    	try {
    		conn = DBConnection.getConnection();
    		conn.setAutoCommit(false);
    		order_dao.updateDeliveryDate(conn, order_id, date);
    		conn.commit();
    	}catch(SQLException e) {
    		if (conn!=null) {
    			try {
					conn.rollback();
				} catch (SQLException e1) {
					throw new RollBackException("failed to rollback transaction");
				}
    			throw new DataAccessException("failed to update delivery date");
    		}
    	}finally{
    		if (conn!=null) {
    			try {
					conn.close();
				} catch (SQLException e) {
					throw new CloseConnectionException("failed to close connection");
				}
    		}
    	}
    	
    }

}
