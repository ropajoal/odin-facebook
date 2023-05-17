import React, { useState, useEffect } from 'react'
import ChatWindow from './ChatWindow'

const ws = new WebSocket("ws://localhost:3000/cable")

export default function Chat ({authenticityToken,friends,userId}){
  console.log(friends);
  const [messages, setMessages] = useState([]);
  //const [guid, setGuid] = useState("");
  const [interlocutorEmail, setInterlocutorEmail] = useState("");
  const messagesContainer = document.getElementById("messages");

  function useForceUpdate(){
    const [value, setValue] = useState(0);
    return () => setValue(value => value + 1)
  }

  ws.onopen = () => {
    console.log("Connected to websocket server");
    //setGuid(Math.random().toString(36).substring(2, 15));
  };

  ws.onmessage = (e) => {
    const data = JSON.parse(e.data);
    if (data.type === "ping") return;
    if (data.type === "welcome") return;
    if (data.type === "confirm_subscription") return;

    const message = data.message;
    setMessagesAndScrollDown([...messages, message]);

  };

  // TODO Change the event to fetch past messages of email
  useEffect(() => {
    Array.from(document.getElementsByClassName("emailsOfFriends")).forEach((li)=>li.addEventListener("click",(e)=>{
      // Fetch all messages of the user with his interlocutor
      setInterlocutorEmail(li.textContent);
      let email = li.textContent
      fetchMessages(email);
      
      ws.send(
        JSON.stringify({
          command: "subscribe",
          identifier: JSON.stringify({
            //id: guid,
            channel: "MessagesChannel",
            email
          }),
        })
      );
    }))
  }, []);

  useEffect(() => {
    resetScroll();
  }, [messages]);

  const handleSubmit = async (e) => {
    e.preventDefault();
    console.log(e.target.message)
    const body = e.target.message.value;
    console.log(body)
    e.target.message.value = "";
    // FIX stream
    await fetch("http://localhost:3000/messages.json", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({ body, interlocutorEmail: interlocutorEmail, authenticity_token: authenticityToken }),
    });
  };

  const fetchMessages = async (email) => {
    console.log("Email: ",email)
    const response = await fetch("http://localhost:3000/messages.json?"+new URLSearchParams({interlocutorEmail: email}));
    const data = await response.json();
    setMessagesAndScrollDown(data);
  };

  const setMessagesAndScrollDown = (data) => {
    setMessages(data);
    resetScroll();
  };

  const resetScroll = () => {
    if (!messagesContainer) return;
    messagesContainer.scrollTop = messagesContainer.scrollHeight;
  };
    //const forceUpdate = useForceUpdate()
  return (
    <div className="Chat">
      <div className="messageHeader">
        <h1>Messages</h1>
        <p>Usuario: {interlocutorEmail}</p>
      </div>
      <div className="messages" id="messages">
        {messages.map((message) => (
          <div className={"message " + (message.sender == userId) ? "currentUserMes" : "interlocutorMes"} key={message.id}>
            <p>{message.body}</p>
          </div>
        ))}
      </div>
      <div className="messageForm">
        <form onSubmit={handleSubmit}>
          <input className="messageInput" type="text" name="message" />
          <button className="messageButton" type="submit">
            Send
          </button>
        </form>
      </div>
    </div>
  )
}
