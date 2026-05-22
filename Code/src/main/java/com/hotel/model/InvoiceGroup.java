package com.hotel.model;

import java.math.BigDecimal;
import java.util.Date;

public class InvoiceGroup {
    private int bookingId;
    private String bookingCode;
    private String customerName;
    private Date issueDate;
    private BigDecimal totalAmount;
    private String paymentMethod;
    private int notCheckedOutCount;
    private java.util.List<Invoice> invoices = new java.util.ArrayList<>();

    public InvoiceGroup() {}

    public InvoiceGroup(Invoice inv) {
        this.bookingId = inv.getBookingId();
        this.bookingCode = inv.getBookingCode();
        this.customerName = inv.getCustomerName();
        this.issueDate = inv.getIssueDate();
        this.totalAmount = inv.getTotalAmount();
        this.paymentMethod = inv.getPaymentMethod();
        this.invoices.add(inv);
    }

    public void addInvoice(Invoice inv) {
        this.invoices.add(inv);
        if (this.totalAmount == null) this.totalAmount = BigDecimal.ZERO;
        if (inv.getTotalAmount() != null) {
            this.totalAmount = this.totalAmount.add(inv.getTotalAmount());
        }
        // Keep the latest issueDate
        if (inv.getIssueDate() != null && (this.issueDate == null || inv.getIssueDate().after(this.issueDate))) {
            this.issueDate = inv.getIssueDate();
            this.paymentMethod = inv.getPaymentMethod();
        }
    }

    public int getBookingId() { return bookingId; }
    public void setBookingId(int bookingId) { this.bookingId = bookingId; }
    public String getBookingCode() { return bookingCode; }
    public void setBookingCode(String bookingCode) { this.bookingCode = bookingCode; }
    public String getCustomerName() { return customerName; }
    public void setCustomerName(String customerName) { this.customerName = customerName; }
    public Date getIssueDate() { return issueDate; }
    public void setIssueDate(Date issueDate) { this.issueDate = issueDate; }
    public BigDecimal getTotalAmount() { return totalAmount; }
    public void setTotalAmount(BigDecimal totalAmount) { this.totalAmount = totalAmount; }
    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }
    public int getNotCheckedOutCount() { return notCheckedOutCount; }
    public void setNotCheckedOutCount(int notCheckedOutCount) { this.notCheckedOutCount = notCheckedOutCount; }
    public java.util.List<Invoice> getInvoices() { return invoices; }
    public void setInvoices(java.util.List<Invoice> invoices) { this.invoices = invoices; }
}
