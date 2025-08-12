//
//  PatungViewModel.swift
//  KalcerPOC
//
//  Created by Gede Pramananda Kusuma Wisesa on 12/08/25.
//

import Foundation
import Supabase

enum Table {
    static let patungs = "patungs"
}

class PatungViewModel: ObservableObject {
    @Published var patungs = [Patung]()
    @Published var isLoading = false
    @Published var isError: String? = nil
    
    let supabase: SupabaseClient
    init() {
        guard let url = URL(string: Secrets.supabaseURL) else {
            fatalError("Invalid Supabase URL: \(Secrets.supabaseURL)")
        }
        
        self.supabase = SupabaseClient(
            supabaseURL: url,
            supabaseKey: Secrets.supabaseKey
        )

    }
    
//        let supabase = SupabaseClient(
//            supabaseURL: URL(string: "https://zlimpccmkbcahceguzxs.supabase.co")!,
//            supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InpsaW1wY2Nta2JjYWhjZWd1enhzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTQ5MDMyOTAsImV4cCI6MjA3MDQ3OTI5MH0.wfS5G7IaRk5-i466Bad4NBXm0pDN3l-K8BQEbN65IiU"
//        )
    
    
    func getPatungs() async throws {
        do  {
            DispatchQueue.main.async {
                self.isLoading = true
            }
            
            let patungs: [Patung] = try await supabase
                .from(Table.patungs)
                .select()
                .order("created_at", ascending: false)
                .execute()
                .value
            
            print("Patung List: \(patungs)")
            
            DispatchQueue.main.async {
                self.patungs = patungs
                self.isLoading = false
                self.isError = nil
            }
        } catch let error as PostgrestError {
            DispatchQueue.main.async {
                self.isLoading = false
                self.isError = error.localizedDescription
            }
        } catch let error as URLError {
            DispatchQueue.main.async {
                self.isLoading = false
                self.isError = error.localizedDescription
            }
        } catch {
            DispatchQueue.main.async {
                self.isLoading = false
                self.isError = error.localizedDescription
            }
        }
    }
}
