//
//  PopUpView 2.swift
//  calendarTest
//
//  Created by David Medina on 12/4/24.
//

import SwiftUI

struct CreateEventView: View {
    @State private var title: String = ""
    @State private var eventDate = Date()
    var components = DateComponents(hour: Calendar.current.component(.hour, from: Date()), minute: Calendar.current.component(.minute, from: Date()))
    @State var eventStartTime: Date
    @State var eventEndTime: Date
    @State var dayList: [String] = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    @EnvironmentObject var scheduleViewModel: ScheduleViewModel
    @State var location: String = ""
    @Environment(\.presentationMode) var presentationMode
    
    init() {
        let calendar = Calendar.current
        let now = Date()
        let hour = calendar.component(.hour, from: now)
        let minute = calendar.component(.minute, from: now)

        // Initialize start time with current hour and minute
        var startComponents = DateComponents()
        startComponents.hour = hour
        startComponents.minute = minute
        _eventStartTime = State(initialValue: calendar.date(from: startComponents)!)

        // Initialize end time with one hour added to the start time
        var endComponents = DateComponents()
        endComponents.hour = hour + 1 // Add one hour
        endComponents.minute = minute
        _eventEndTime = State(initialValue: calendar.date(from: endComponents)!)
    }
    
    var body: some View {
        VStack(spacing: 15) {
            HStack(spacing: 12) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                            .font(.system(size: 24, weight: .medium))
                            .labelStyle(.titleAndIcon)
                            .foregroundStyle(Color.primary)
                }
                Text("Create New Event")
                    .foregroundStyle(Color.primary)
                    .font(.system(size: 25, weight: .bold))
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.systemBackground))
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .center, spacing: 30) {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Title")
                                .font(.system(size: 20, weight: .regular, design: .monospaced))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        
                        RoundedRectangle(cornerRadius: 10)
                            .frame(maxWidth: .infinity, maxHeight: 100)
                            .padding(.horizontal)
                            .foregroundStyle(Color.gray.opacity(0.2))
                            .overlay {
                                TextField("Enter a title", text: $title)
                                    .foregroundStyle(Color.red)
                                    .padding(.horizontal)
                                    .padding(.leading, 15)
                            }
                            .frame(height: 45)
                    }
                    .padding(.horizontal)
                    
                    HStack {
                        Text("Event Date")
                            .font(.system(size: 20, weight: .regular, design: .monospaced))
                            .padding(.horizontal)
                        
                        DatePicker(
                            "",
                            selection: $eventDate,
                            displayedComponents: [.date]
                        )
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.horizontal)
                        .labelsHidden()
                    }
                    .padding(.horizontal)
                    
                    HStack {
                        VStack {
                            Text("Start Time")
                                .font(.system(size: 20, weight: .regular, design: .monospaced))
                                .padding(.horizontal)
                            
                            DatePicker("", selection: $eventStartTime, displayedComponents: [.hourAndMinute])
                                .frame(maxWidth: .infinity)
                                .padding(.horizontal)
                                .labelsHidden()
                        }
                        Spacer()
                        VStack {
                            Text("End Time")
                                .font(.system(size: 20, weight: .regular, design: .monospaced))
                                .padding(.horizontal)
                            
                            DatePicker("", selection: $eventEndTime, displayedComponents: [.hourAndMinute])
                                .frame(maxWidth: .infinity)
                                .padding(.horizontal)
                                .labelsHidden()

                        }
                    }
                    
                    RoundedRectangle(cornerRadius: 10)
                        .frame(maxWidth: .infinity, minHeight: 80)
                        .foregroundStyle(Color(.systemBackground))
                        .overlay {
                            VStack {
                                HStack(spacing: 15) {
                                    ForEach(dayList, id: \.self) { day in
                                        VStack(alignment: .center, spacing: 10) {
                                            Text(day)
                                                .font(.system(size: 20, weight: .regular, design: .rounded))
                                            Button(action: {}) {
                                                RoundedRectangle(cornerRadius: 5)
                                                    .foregroundStyle(Color.gray.opacity(0.2))
                                                    .frame(width: 30, height: 30)
                                            }
                                        }
                                    }
                                }
                                .frame(maxWidth: .infinity, maxHeight: 75)
                                .padding(.horizontal)
                                .cornerRadius(15)
                            }
                            .frame(maxWidth: .infinity, alignment: .top)
                        }
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Location")
                                .font(.system(size: 20, weight: .regular, design: .monospaced))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        
                        RoundedRectangle(cornerRadius: 10)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                            .foregroundStyle(Color.gray.opacity(0.2))
                            .overlay {
                                TextField("Enter Location", text: $location)
                                    .foregroundStyle(Color.red)
                                    .padding(.horizontal)
                                    .padding(.leading, 15)
                            }
                            .frame(height: 45)
                    }
                    .padding(.horizontal)
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Tagged Users")
                                .font(.system(size: 20, weight: .regular, design: .monospaced))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        
                        RoundedRectangle(cornerRadius: 10)
                            .frame(maxWidth: .infinity, maxHeight: 100)
                            .padding(.horizontal)
                            .foregroundStyle(Color.gray.opacity(0.2))
                            .overlay {
                                TextField("Enter Location", text: $location)
                                    .foregroundStyle(Color.red)
                                    .padding(.horizontal)
                                    .padding(.leading, 15)
                            }
                            .frame(height: 45)
                    }
                    .padding(.horizontal)
                    
                    Button(action: {
                        Task {
                            print(eventDate)
                            let newEvent: Event = scheduleViewModel.makeNewEvent(title: title, eventDate: Date.computeTimeSince1970(date: eventDate), startTime: Date.computeTimeSinceStartOfDay(date: eventStartTime), endTime: Date.computeTimeSinceStartOfDay(date: eventEndTime))
                            await scheduleViewModel.createEvent(newEvent: newEvent)
                            presentationMode.wrappedValue.dismiss()
                        }
                    }) {
                        RoundedRectangle(cornerRadius: 10)
                            .padding(.horizontal)
                            .overlay {
                                Text("Create Event")
                                    .foregroundColor(Color.white)
                                    .font(.headline)
                            }
                    }
                    .frame(maxWidth: .infinity, minHeight: 45)
                    .padding()
                    .foregroundStyle(Color("FormButtons"))
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("DarkBackground"))
        .navigationBarBackButtonHidden(true)
    }
}
