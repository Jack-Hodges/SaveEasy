import SwiftUI

struct SwipeCard: View {
    
    @ObservedObject var authViewModel: AuthViewModel
    @Environment(\.colorScheme) var colorScheme
    @Binding var cardOffset: CGFloat
    @State private var dragOffset: CGFloat = 0
    @State private var selectedJob: Job? = nil
    @State private var isJobSheetPresented: Bool = false
    @State private var isAddJobSheetPresented: Bool = false
    @State private var isBottomPlacement: Bool = true

    let maxHeight = UIScreen.main.bounds.height

    var body: some View {
        let primaryCol = authViewModel.user!.colourScheme.primaryColour
        
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 30)
                    .fill(Color("PrimaryBackgroundColor"))
                    .shadow(radius: 10)
                VStack {
                    HStack {
                        Text("Jobs")
                            .font(.system(size: 50))
                            .fontWeight(.heavy)
                            .foregroundStyle(Color("PrimaryTextColor"))
                        Spacer()
                    }

                    HStack {
                        Text("Up Next")
                            .font(.system(size: 30))
                            .fontWeight(.bold)
                            .foregroundStyle(Color("PrimaryTextColor"))
                        Spacer()
                    }

                    ScrollView {
                        if (authViewModel.user!.jobs.isEmpty) {
                            Text("No jobs left!")
                        } else {
                            ForEach(authViewModel.user!.jobs) { job in
                                JobSegment(job: job, authViewModel: authViewModel)
                                    .onTapGesture {
                                        selectedJob = job
                                        isJobSheetPresented = true
                                    }
                                    .padding(.top, 5)
                                    .padding(.bottom, 15)
                            }
                        }
                        
                    }
                    .padding(-10)
                    
                    Spacer()
                }
                .padding(10)
            }
            .offset(y: cardOffset + dragOffset)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        // stops the card from being dragged further than the max snap point
                        if ((cardOffset + dragOffset) > -391) {
                            dragOffset = value.translation.height
                        }
                        
                    }
                    .onEnded { value in
                        cardOffset += dragOffset
                        dragOffset = 0

                        withAnimation {
                            if isBottomPlacement {
                                if cardOffset < -50 {
                                    cardOffset = -390 // Snap to top position
                                    isBottomPlacement = false
                                } else {
                                    cardOffset = 60 // Snap back to bottom position
                                }
                            } else {
                                if cardOffset > -340 {
                                    cardOffset = 0 // Snap to bottom position
                                    isBottomPlacement = true
                                } else {
                                    cardOffset = -390 // Snap back to top position
                                }
                            }
                        }
                    }
            )
            .sheet(item: $selectedJob) { job in
                JobDetailView(job: job, authViewModel: authViewModel)
            }
            .sheet(isPresented: $isAddJobSheetPresented) {
                AddJobView(authViewModel: authViewModel)
            }
        }
    }
}

#Preview {
    SwipeCard(authViewModel: AuthViewModel(), cardOffset: .constant(0))
}
