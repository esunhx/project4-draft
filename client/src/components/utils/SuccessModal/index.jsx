const SuccessModal = (props) => {
    const onClickHandler = () => {
      props.onClick();
    };
  
    return (
      <div
        onClick={onClickHandler}>
        <div>{props.message}</div>
      </div>
    );
  };
  
  export default SuccessModal;