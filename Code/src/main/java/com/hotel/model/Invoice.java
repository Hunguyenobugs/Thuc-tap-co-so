package com.hotel.model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class Invoice {
    private int id;
    private String code;
    private int bookingId;
    private Integer staffId;
    private Timestamp issueDate;
    private BigDecimal roomTotal;
    private BigDecimal serviceTotal;
    private BigDecimal surcharge;
    private BigDecimal totalAmount;
    private BigDecimal paidAmount;
    private String paymentMethod;
    private String note;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    private String customerName;
    private String staffName;
    private String bookingCode;

    public Invoice() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getCode() { return code; }
    public void setCode(String code) { this.code = code; }
    public int getBookingId() { return bookingId; }
    public void setBookingId(int bookingId) { this.bookingId = bookingId; }
    public Integer getStaffId() { return staffId; }
    public void setStaffId(Integer staffId) { this.staffId = staffId; }
    public Timestamp getIssueDate() { return issueDate; }
    public void setIssueDate(Timestamp issueDate) { this.issueDate = issueDate; }
    public BigDecimal getRoomTotal() { return roomTotal; }
    public void setRoomTotal(BigDecimal roomTotal) { this.roomTotal = roomTotal; }
    public BigDecimal getServiceTotal() { return serviceTotal; }
    public void setServiceTotal(BigDecimal serviceTotal) { this.serviceTotal = serviceTotal; }
    public BigDecimal getSurcharge() { return surcharge; }
    public void setSurcharge(BigDecimal surcharge) { this.surcharge = surcharge; }
    public BigDecimal getTotalAmount() { return totalAmount; }
    public void setTotalAmount(BigDecimal totalAmount) { this.totalAmount = totalAmount; }
    public BigDecimal getPaidAmount() { return paidAmount; }
    public void setPaidAmount(BigDecimal paidAmount) { this.paidAmount = paidAmount; }
    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }
    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }
    public String getCustomerName() { return customerName; }
    public void setCustomerName(String customerName) { this.customerName = customerName; }
    public String getStaffName() { return staffName; }
    public void setStaffName(String staffName) { this.staffName = staffName; }
    public String getBookingCode() { return bookingCode; }
    public void setBookingCode(String bookingCode) { this.bookingCode = bookingCode; }
}
