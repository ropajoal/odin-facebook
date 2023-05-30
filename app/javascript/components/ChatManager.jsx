import React, { useState, useEffect } from 'react' 
import ChatWindow from './ChatWindow'


export default function Chat ({friends,userId}){

  const [activeFriends, setActiveFriends] = useState([])

  useEffect(() => {
    
  }, []);

  const openChat = (friend) =>{
    if(activeFriends.some(af=>af[0]==friend)) return
    setActiveFriends((activeFriends)=>[...activeFriends, [friend,<ChatWindow {...{ friend, userId } } />
]])
  }

  const removeChat = (id)=>{
    setActiveFriends(activeFriends.filter((_,index)=>index!=id))
  }

  useEffect(()=>{
  },[activeFriends])


  return (
    <div id="friendList">
      {friends.map((friend)=>(
        <li className="friendsUsernames" onClick={()=>openChat(friend)} key={friend.id}>{friend.username}</li>
      ))}
      {
        activeFriends.map((act,i)=> (
          <div className="chatBox" style={{bottom:0, right:`${i * 410}px`}} key={i}>
            <div className="messageHeader">
              <h4>{act[0].username}</h4>
              <div>
              <a data-bs-toggle="collapse" className="float-right" data-bs-target={"#messages_"+act[0].username}>
                <i className="bi bi-chevron-down"></i>
              </a>
              <button type="button" className="btn-close" onClick={()=>removeChat(i)}></button>
              </div>
            </div>
            {act[1]} 
          </div>
        ))
      }
    </div>
  )
}
