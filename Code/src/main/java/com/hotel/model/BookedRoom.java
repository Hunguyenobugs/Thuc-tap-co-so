package com.hotel.model;

import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Timestamp;

public class BookedRoom {
    private int id;
    private int bookingId;
    private int roomId;
    private Date checkIn;
    private Date checkOut;
    private Timestamp actualCheckin;
    private Timestamp actualCheckout;
    private BigDecimal actualPrice;
    private boolean isCheckedIn;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    private String roomNumber;
    private String roomTypeName;

    public BookedRoom() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getBookingId() { return bookingId; }
    public void setBookingId(int bookingId) { this.bookingId = bookingId; }
    public int getRoomId() { return roomId; }
    public void setRoomId(int roomId) { this.roomId = roomId; }
    public Date getCheckIn() { return checkIn; }
    public void setCheckIn(Date checkIn) { this.checkIn = checkIn; }
    public Date getCheckOut() { return checkOut; }
    public void setCheckOut(Date checkOut) { this.checkOut = checkOut; }
    public Timestamp getActualCheckin() { return actualCheckin; }
    public void setActualCheckin(Timestamp actualCheckin) { this.actualCheckin = actualCheckin; }
    public Timestamp getActualCheckout() { return actualCheckout; }
    public void setActualCheckout(Timestamp actualCheckout) { this.actualCheckout = actualCheckout; }
    public BigDecimal getActualPrice() { return actualPrice; }
    public void setActualPrice(BigDecimal actualPrice) { this.actualPrice = actualPrice; }
    public boolean isCheckedIn() { return isCheckedIn; }
    public void setCheckedIn(boolean checkedIn) { isCheckedIn = checkedIn; }
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }
    public String getRoomNumber() { return roomNumber; }
    public void setRoomNumber(String roomNumber) { this.roomNumber = roomNumber; }
    public String getRoomTypeName() { return roomTypeName; }
    public void setRoomTypeName(String roomTypeName) { this.roomTypeName = roomTypeName; }
}
