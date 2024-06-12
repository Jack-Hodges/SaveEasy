import SwiftUI

struct AddJobView: View {
    @ObservedObject var authViewModel: AuthViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var jobName: String = ""
    @State private var jobPrice: Double = 0.0
    @State private var jobDueDate: Date? = nil
    @State private var selectedImage: String = "Briefcase"
    @State private var description: String = ""
    @State private var dateToggle: Bool = false
    @State private var selectedChildEmails: [String] = []
    
    // Array of image names from the Assets folder
    let imageNames = ["Briefcase", "Dishwasher", "Vacuum", "Laundry", "Gardening"]
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        
        let primCol = authViewModel.user!.colourScheme.primaryColour
        let inputWidth: CGFloat = 320
        
        ZStack {
            
            Color(Color("PrimaryBackgroundColor"))
                .ignoresSafeArea()
            
            VStack {
                
                HStack {
                    Spacer()
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("Close")
                            .foregroundStyle(authViewModel.user!.colourScheme.primaryColour)
                            .bold()
                    })
                    
                }
                .padding()
                
                Text("New Job")
                    .font(.system(size: 50))
                    .fontWeight(.heavy)
                    .foregroundStyle(primCol)
                    .padding(.top, -10)
                
//                Spacer()
                
                ScrollView {
                    VStack(alignment: .leading) {
                        Text("Job Name*")
                            .inputTitle(color: primCol)
                        TextField("Job Name", text: $jobName)
                            .frame(width: inputWidth)
                            .neumorphicStyle(cornerRadius: 15, color: Color(UIColor.systemBackground))
                    }
                    .padding(.bottom, 10)
                    
                    VStack(alignment: .leading) {
                        Text("Job Price*")
                            .inputTitle(color: primCol)
                        TextField("Job Price", value: $jobPrice, format: .number)
                            .keyboardType(.decimalPad)
                            .frame(width: inputWidth)
                            .neumorphicStyle(cornerRadius: 15, color: Color(UIColor.systemBackground))
                    }
                    .padding(.bottom, 10)
                    
                    VStack(alignment: .leading) {
                        Text("Job Description")
                            .inputTitle(color: primCol)
                        TextEditor(text: $description)
                            .frame(width: inputWidth, height: 100) // Adjust height as needed
                            .neumorphicStyle(cornerRadius: 15, color: Color(UIColor.systemBackground))
                            .padding(.bottom, 10)
                    }
                    
                    HStack(alignment: .top) {
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Due Date")
                                    .inputTitle(color: primCol)
                                Toggle(isOn: $dateToggle) {
                                    Text("")
                                }
                                .labelsHidden()
                                .inputTitle(color: primCol)
                            }
                            if dateToggle {
                                DatePicker("", selection: Binding(
                                    get: { jobDueDate ?? Date() },
                                    set: { jobDueDate = $0 }
                                ), displayedComponents: [.date, .hourAndMinute])
                                .labelsHidden()
                                .frame(width: inputWidth / 1.5, height: 40)
                                .neumorphicStyle(cornerRadius: 15, color: Color(UIColor.systemBackground))
                            } else {
                                ZStack {
                                    Rectangle()
                                        .fill(Color(UIColor.systemBackground))
                                        .frame(width: inputWidth / 1.5, height: 40)
                                        .neumorphicStyle(cornerRadius: 15, color: Color(UIColor.systemBackground))
                                    Text("No due date")
                                        .foregroundStyle(Color("PrimaryTextColor"))
                                        .font(.title)
                                        .bold()
                                }
                            }
                            
                        }
                        .padding(.bottom, 10)
                        .padding(.leading, -15)
                        
                        VStack(alignment: .leading) {
                            Text("Image")
                                .inputTitle(color: primCol)
                                .padding(.leading, -10)
                                .padding(.bottom, 10)
                            Menu {
                                ForEach(imageNames, id: \.self) { imageName in
                                    Button(action: {
                                        selectedImage = imageName
                                    }) {
                                        HStack {
                                            Image(imageName)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 50, height: 50)
                                            Text(imageName)
                                        }
                                    }
                                }
                            } label: {
                                HStack {
                                    Image(selectedImage)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 50, height: 50)
                                }
                                .frame(width: inputWidth / 8, height: 50)
                                .padding()
                                .background(Color(UIColor.systemBackground))
                                .cornerRadius(15)
                            }
                            .padding(.top, 6)
                        }
                    }
                    VStack(alignment: .leading) {
                        Text("Job Assignment")
                            .inputTitle(color: primCol)
                        LazyVGrid(columns: columns) {
                            ForEach(authViewModel.user!.childLinkedAccounts) { child in
                                let isSelected = selectedChildEmails.contains(child.email)
                                ZStack {
                                    Text(child.firstName)
                                        .frame(width: 175, height: 60)
                                        .background(.white)
                                    
                                    if (isSelected) {
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke((authViewModel.user?.colourScheme.primaryColour)!, lineWidth: 4)
                                            .frame(width: 160, height: 45)
                                    }
                                        
                                }
                                .cornerRadius(10)
                                .onTapGesture {
                                    if isSelected {
                                        selectedChildEmails.removeAll { $0 == child.email }
                                    } else {
                                        selectedChildEmails.append(child.email)
                                    }
                                }
                            }
                        }
                        .padding(.top, 10)
                        .padding(.horizontal, 10)
                    }
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 50)
                            .frame(width: 250, height: 50)
                            .foregroundColor(authViewModel.user!.colourScheme.primaryColour)
                        Button("Add Job") {
                            if jobName != "" {
                                let newJob = Job(id: UUID().uuidString, name: jobName, dueDate: dateToggle ? jobDueDate : nil, price: jobPrice, image: selectedImage, description: description)
                                authViewModel.user!.jobs.append(newJob)
                                authViewModel.user!.jobs.sort { ($0.dueDate ?? Date.distantFuture) < ($1.dueDate ?? Date.distantFuture) }
                                print(authViewModel.user!.jobs)
                                authViewModel.dataManager.updateUser(authViewModel.user!)
                                
                                // Push the new job to the selected child accounts
                                authViewModel.dataManager.pushChildJobs(users: authViewModel.user!.childLinkedAccounts, pushTo: selectedChildEmails, newJob: newJob)
                                
                                presentationMode.wrappedValue.dismiss()
                            }
                        }
                        .foregroundStyle(.white)
                        .font(.title)
                        .bold()
                    }
                    
                }
                
                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    AddJobView(authViewModel: AuthViewModel())
}
