package com.hotel.model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class UsedService {
    private int id;
    private int bookingId;
    private int serviceId;
    private BigDecimal quantity;
    private BigDecimal unitPrice;
    private Timestamp usedDate;
    private String note;
    private Timestamp createdAt;

    private String serviceName;
    private String serviceUnit;

    public UsedService() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getBookingId() { return bookingId; }
    public void setBookingId(int bookingId) { this.bookingId = bookingId; }
    public int getServiceId() { return serviceId; }
    public void setServiceId(int serviceId) { this.serviceId = serviceId; }
    public BigDecimal getQuantity() { return quantity; }
    public void setQuantity(BigDecimal quantity) { this.quantity = quantity; }
    public BigDecimal getUnitPrice() { return unitPrice; }
    public void setUnitPrice(BigDecimal unitPrice) { this.unitPrice = unitPrice; }
    public Timestamp getUsedDate() { return usedDate; }
    public void setUsedDate(Timestamp usedDate) { this.usedDate = usedDate; }
    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    public String getServiceName() { return serviceName; }
    public void setServiceName(String serviceName) { this.serviceName = serviceName; }
    public String getServiceUnit() { return serviceUnit; }
    public void setServiceUnit(String serviceUnit) { this.serviceUnit = serviceUnit; }

    public BigDecimal getSubtotal() {
        if (quantity != null && unitPrice != null) {
            return quantity.multiply(unitPrice);
        }
        return BigDecimal.ZERO;
    }
}
