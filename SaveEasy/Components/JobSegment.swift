import SwiftUI

struct JobSegment: View {
    
    @State var job: Job
    @ObservedObject var authViewModel: AuthViewModel
    @Environment(\.colorScheme) var colorScheme
    @State var jobCol: Color = .gray
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(colorScheme == .dark ? Color.black : Color.white)
            
            HStack {
                
                Image(job.image)
                    .resizable()
                    .frame(width: 50, height: 50)
                    .padding(.leading, -10)
                
                VStack(alignment: .leading) {
                    Text(job.name)
                        .font(.title2)
                        .fontWeight(.bold)
                        .fixedSize(horizontal: false, vertical: true)
                        .foregroundStyle(Color("PrimaryTextColor"))
                    
                    HStack {
                        Image(systemName: "clock")
                        Text("\(job.dueDateString)")
                            .padding(.leading, -5)
                    }
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(jobCol)
                }
                .onAppear {
                    if job.dueDateString == "Overdue" {
                        jobCol = .red
                    } else {
                        jobCol = .gray
                    }
                }
                
                Spacer()
                
                Text(priceString(price: job.price))
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(authViewModel.user!.colourScheme.primaryColour)
            }
            .padding(.horizontal)
        }
        .frame(height: 65)
        .padding(.horizontal, 10)
        .padding(.bottom, -20)
    }
}

#Preview {
    JobSegment(job: sampleJobs[0], authViewModel: AuthViewModel())
}
