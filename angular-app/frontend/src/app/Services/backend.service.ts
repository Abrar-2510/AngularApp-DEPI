import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class BackendService {

  constructor(private http:HttpClient) { }

  private API_URL = 'http://44.202.120.118:3000'

  getMessage(): Observable<{ message: string; dbStatus: string }> {
    return this.http.get<{ message: string; dbStatus: string }>(`${this.API_URL}`);
  }
  
}
